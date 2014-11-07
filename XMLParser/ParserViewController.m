//
//  ParserViewController.m
//  XMLParser
//
//  Created by Mubashir Meddekar on 12/09/2014.
//  Copyright (c) 2014 Mubashir Meddekar. All rights reserved.
//

#import "ParserViewController.h"

@interface ParserViewController ()

@end

@implementation ParserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"Done receiving bytes %d",[webData length]);
    NSString *theXML = [[NSString alloc]initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", theXML);
    
    if(!xmlParser){
        xmlParser = [[NSXMLParser alloc]initWithData:webData];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:matchingElement]){
        if(!soapResults){
            soapResults = [[NSMutableString alloc]init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(elementFound){
        [soapResults appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:matchingElement]){
        NSLog(@"%@",soapResults);
        
        float temperatureRate = [soapResults floatValue];
//        float result = [self.myText.text floatValue] * temperatureRate;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Result" message:[NSString stringWithFormat:@"Converted Temperature is @%f",temperatureRate] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        elementFound = false;
        [xmlParser abortParsing];
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(soapResults){
        soapResults = nil;
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if(soapResults){
        soapResults = nil;
    }
}
- (IBAction)buttonPressed:(id)sender {
    matchingElement = @"CelsiusToFahrenheitResult";
    
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><CelsiusToFahrenheit xmlns=\"http://www.w3schools.com/webservices/\"><Celsius>%@</Celsius> </CelsiusToFahrenheit></soap12:Body></soap12:Envelope>",self.myText.text];

//    NSLog(@"%@",soapMsg);
    
    NSURL *url = [NSURL URLWithString:@"http://www.w3schools.com/webservices/tempconvert.asmx?op=CelsiusToFahrenheit"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *length = [NSString stringWithFormat:@"%i",[soapMsg length]];
    
    [req addValue:@"text/xml; chartset = utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [req addValue:length forHTTPHeaderField:@"Content-length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    
    if(conn){
        webData = [NSMutableData data];
    }
}
@end
