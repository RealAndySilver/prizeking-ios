//
//  ServerCommunicator.m
//  PrizeKing
//
//  Created by Andres Abril on 10/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunicator.h"

@implementation ServerCommunicator
@synthesize dictionary,tag,caller,objectDic,resDic;
-(id)init {
    self = [super init];
    if (self) {
        tag = 0;
        caller = nil;
        webData = nil;
        theConnection = nil;
    }
    return self;
}
-(void)callServerWithMethod:(NSString*)method
               andParameter:(NSString*)parameter{
    NSString *hash=[IAmCoder hash256:parameter];
    NSString *params2=[parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *stringUrl=[NSString stringWithFormat:@"http://10.0.1.14/PriceKingWCF/pk_wcf.svc/%@/%@/%@",method,params2,hash];
    NSString *stringUrl=[NSString stringWithFormat:@"http://whackimole.com/PK_WCF.svc/%@/%@/%@",method,params2,hash];
    NSLog(@"string url: %@",stringUrl);
    
    
	NSURL *url=[NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    /*[request addValue:@"soyUnHeaderCustomizado" forHTTPHeaderField:@"CustomHeader"];
    [request setValue:@"soyelfrom" forHTTPHeaderField:@"From"];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];*/
    
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    
    NSLog(@"Request----> %@",request);
    NSLog(@"%@", [request allHTTPHeaderFields]);
    dictionary = [[NSDictionary alloc]init];
	if(theConnection) {
		webData = [NSMutableData data];
	}
	else {
		NSLog(@"theConnection is NULL");
	}
}

//Implement the NSURL and XMLParser protocols
#pragma mark -
#pragma mark NSURLConnection methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webData setLength:0];
	NSLog(@"didReceiveresponse");
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webData appendData:data];
	NSLog(@"didReceiveData");
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"didFailWithError %@",error);
    if ([caller respondsToSelector:@selector(receivedDataFromServerWithError:)]) {
        [caller performSelector:@selector(receivedDataFromServerWithError:) withObject:self];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSMutableDictionary *jsonDictionary=[NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    SBJSON *json=[[SBJSON alloc]init];
    NSString *json_string = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dit=[json objectWithString:json_string error:nil];    //NSLog(@"Todos los datos recibidos JSON %@",jsonDictionary);
    //resDic=jsonDictionary;
    resDic=dit;
    NSLog(@"json %@",resDic);

    if ([caller respondsToSelector:@selector(receivedDataFromServer:)]) {
        [caller performSelector:@selector(receivedDataFromServer:) withObject:self];
    }
}

@end
