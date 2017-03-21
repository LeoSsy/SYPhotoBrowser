//
//  NSString+SY.m
//  photo
//
//  Created by shushaoyong on 2016/10/24.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import "NSString+SY.h"
#import <CommonCrypto/CommonDigest.h>
#include <stdint.h>
#include <stdio.h>

#define FileHashComputationContextInitialize(context, hashAlgorithmName)                    \
CC_##hashAlgorithmName##_CTX hashObjectFor##hashAlgorithmName;                          \
context.initFunction      = (FileHashInitFunction)&CC_##hashAlgorithmName##_Init;       \
context.updateFunction    = (FileHashUpdateFunction)&CC_##hashAlgorithmName##_Update;   \
context.finalFunction     = (FileHashFinalFunction)&CC_##hashAlgorithmName##_Final;     \
context.digestLength      = CC_##hashAlgorithmName##_DIGEST_LENGTH;                     \
context.hashObjectPointer = (uint8_t **)&hashObjectFor##hashAlgorithmName

static const size_t FileHashDefaultChunkSizeForReadingData = 4096;
typedef int (*FileHashInitFunction)   (uint8_t *hashObjectPointer[]);
typedef int (*FileHashUpdateFunction) (uint8_t *hashObjectPointer[], const void *data, CC_LONG len);
typedef int (*FileHashFinalFunction)  (unsigned char *md, uint8_t *hashObjectPointer[]);

typedef struct _FileHashComputationContext {
    FileHashInitFunction initFunction;
    FileHashUpdateFunction updateFunction;
    FileHashFinalFunction finalFunction;
    size_t digestLength;
    uint8_t **hashObjectPointer;
} FileHashComputationContext;


@implementation NSString (SY)

/**
 *  将一个数组转换为汉字的数字
 *
 *  @param num 数字
 *
 *  @return 返回对应汉字数字
 */
+ (NSString *)numberToChineseCharacter:(NSInteger)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    
    return  [formatter stringFromNumber:[NSNumber numberWithInt: (int)num]];
}
/**
 *  获取一个文件的md5值
 *
 *  @param path 文件地址
 *
 *  @return md5值
 */
+ (NSString *) stringWithMD5OfFile: (NSString *) path {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    BOOL done = NO;
    while (!done) {
        
        NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
        CC_MD5_Update (&md5, [fileData bytes], (CC_LONG) [fileData length]);
        
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

/**
 *  获取一个文件的sha1值公用方法
 *
 *  @param filePath 文件地址
 *  @param context  回调
 *
 *  @return 返回hash值
 */
+ (NSString *)hashOfFileAtPath:(NSString *)filePath withComputationContext:(FileHashComputationContext *)context {
    NSString *result = nil;
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    CFReadStreamRef readStream = fileURL ? CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL) : NULL;
    BOOL didSucceed = readStream ? (BOOL)CFReadStreamOpen(readStream) : NO;
    if (didSucceed) {
        
        // Use default value for the chunk size for reading data.
        const size_t chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
        // Initialize the hash object
        (*context->initFunction)(context->hashObjectPointer);
        
        // Feed the data to the hash object.
        BOOL hasMoreData = YES;
        while (hasMoreData) {
            uint8_t buffer[chunkSizeForReadingData];
            CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));
            if (readBytesCount == -1) {
                break;
            } else if (readBytesCount == 0) {
                hasMoreData = NO;
            } else {
                (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
            }
        }
        
        // Compute the hash digest
        unsigned char digest[context->digestLength];
        (*context->finalFunction)(digest, context->hashObjectPointer);
        
        // Close the read stream.
        CFReadStreamClose(readStream);
        
        // Proceed if the read operation succeeded.
        didSucceed = !hasMoreData;
        if (didSucceed) {
            char hash[2 * sizeof(digest) + 1];
            for (size_t i = 0; i < sizeof(digest); ++i) {
                snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
            }
            result = [NSString stringWithUTF8String:hash];
        }
        
    }
    if (readStream) CFRelease(readStream);
    if (fileURL)    CFRelease(fileURL);
    return result;
}


+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA1);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA512);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

/**
 *  获取md5 hash值
 *
 *  @return 返回hash值
 */
- (NSString *) MD5Hash {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}

/**
 *  获取文件大小
 *
 *  @return 文件大小
 */
- (unsigned long long)getFileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *attri = [mgr attributesOfItemAtPath:self error:&error];
    
    //如果是文件夹
    if ([attri.fileType isEqualToString:NSFileTypeDirectory]) {
        unsigned long long fileSize = 0;
        for (NSString *filePath in [mgr subpathsAtPath:self]) {
           NSString *filep = [self stringByAppendingPathComponent:filePath];
           fileSize += [mgr attributesOfItemAtPath:filep error:&error].fileSize;
        }
        return fileSize;
    }else{
        return  attri.fileSize;
    }
    return  0;
    
}


/**
 *  获取缓存根目录
 *
 *  @return 返回缓存地址
 */
+ (NSString*)cacheDirectory
{

    //创建缓存目录
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SYAllCacheDirectory"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //如果不存在目录就创建
    if (![mgr fileExistsAtPath:cacheDir]) {
        [mgr createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return cacheDir;
}


/**
 *  获取缓存文件路径
 *
 *  @return 返回缓存路径
 */
- (NSString *)cachePath
{
    return [[self.class cacheDirectory] stringByAppendingPathComponent:self];
}


/**
 *
 *将数组转换为json字符串
 */
+ (NSString*)jsonWithArray:(NSArray*)array
{
    
    if (!array)  return nil;
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

/**
 *
 *将json字符串转换为数组
 */
+ (NSArray*)arrayWithJson:(NSString*)json
{
    if (!json) return nil;
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithData:data];
}

/**
 *
 * 通过转好的json格式的data获取数组
 */
+ (NSArray*)arrayWithData:(NSData*)data
{
    if (data==nil) return nil;
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return array;
    
}


/**
 *
 *将字典转换为json字符串
 */
+ (NSString*)jsonWithDictionary:(NSDictionary*)dict
{
    if (!dict)  return nil;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 *
 *将json字符串转换为字典
 */
+ (NSDictionary*)dictionaryWithJson:(NSString*)json
{
    if (!json) return nil;
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    return [self dictionaryWithData:data];
}


/**
 *
 * 通过转好的json格式的data获取字典
 */
+ (NSDictionary*)dictionaryWithData:(NSData*)data
{
    if (data==nil) return nil;
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return dict;
    
}


//计算文字的宽度
- (CGFloat)getTextWidthWithMaxHeight:(CGFloat)height fontSize:(CGFloat)size
{
    
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.width;
    
}

//计算文字的高度
- (CGFloat)getTextWidthWithMaxWidth:(CGFloat)width fontSize:(CGFloat)size
{
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.height;
    
}

@end
