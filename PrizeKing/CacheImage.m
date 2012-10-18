//
//  CacheImage.m
//  PrizeKing
//
//  Created by Andrés Abril on 11/08/12.
//
//

#import "CacheImage.h"

@implementation CacheImage
#define TMP NSTemporaryDirectory()

+(void)cacheImage:(NSString *)ImageURLString{
    NSString *ImageURLStringCopy = [[[[[ImageURLString stringByReplacingOccurrencesOfString:@"/" withString:@"SS"]
                                       stringByReplacingOccurrencesOfString:@"http" withString:@"HH"]
                                      stringByReplacingOccurrencesOfString:@":" withString:@"DD"]
                                     stringByReplacingOccurrencesOfString:@"?" withString:@"II"]
                                    stringByReplacingOccurrencesOfString:@"=" withString:@"EE"];
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
    
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"%@",ImageURLStringCopy];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
        UIImage *image = [[UIImage alloc] initWithData: data];
        
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file

                [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
    }
}

+(UIImage*)getCachedImage:(NSString *)ImageURLString{
    NSString *ImageURLStringCopy = [[[[[ImageURLString stringByReplacingOccurrencesOfString:@"/" withString:@"SS"]
                         stringByReplacingOccurrencesOfString:@"http" withString:@"HH"]
                        stringByReplacingOccurrencesOfString:@":" withString:@"DD"]
                       stringByReplacingOccurrencesOfString:@"?" withString:@"II"]
                      stringByReplacingOccurrencesOfString:@"=" withString:@"EE"];
    
    NSString *filename = [NSString stringWithFormat:@"%@",ImageURLStringCopy];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];

    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
    else
    {
        // get a new one
        //[self cacheImage: ImageURLString];
        [self performSelectorInBackground:@selector(cacheImage:) withObject:ImageURLString];
        image = [UIImage imageWithContentsOfFile: uniquePath];
    }
    
    return image;
}
+(UIImage*)getCachedImage:(NSString *)ImageURLString noThread:(id)null{
    NSString *ImageURLStringCopy = [[[[[ImageURLString stringByReplacingOccurrencesOfString:@"/" withString:@"SS"]
                                       stringByReplacingOccurrencesOfString:@"http" withString:@"HH"]
                                      stringByReplacingOccurrencesOfString:@":" withString:@"DD"]
                                     stringByReplacingOccurrencesOfString:@"?" withString:@"II"]
                                    stringByReplacingOccurrencesOfString:@"=" withString:@"EE"];
    
    NSString *filename = [NSString stringWithFormat:@"%@",ImageURLStringCopy];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
    else
    {
        // get a new one
        [self cacheImage: ImageURLString];
        //[self performSelectorInBackground:@selector(cacheImage:) withObject:ImageURLString];
        image = [UIImage imageWithContentsOfFile: uniquePath];
    }
    
    return image;
}
@end
