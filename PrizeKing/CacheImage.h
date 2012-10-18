//
//  CacheImage.h
//  PrizeKing
//
//  Created by Andrés Abril on 11/08/12.
//
//

#import <Foundation/Foundation.h>

@interface CacheImage : NSObject{
}
+(void)cacheImage:(NSString *)ImageURLString;
+(UIImage *)getCachedImage:(NSString *)ImageURLString;
+(UIImage *)getCachedImage:(NSString *)ImageURLString noThread:(id)null;

@end
