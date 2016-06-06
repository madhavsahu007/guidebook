//
//  MainTableViewController.m
//  Guidebook
//
//  Created by Madhav Devendra Sahu on 6/5/16.
//  Copyright (c) 2016 Madhav Devendra Sahu. All rights reserved.
//

#import "MainTableViewController.h"
#import "Guide.h"

@interface MainTableViewController ()
{
    
    // additional variables
    
    NSMutableArray *startDateArray;
    NSMutableArray *guideArray;
    NSMutableDictionary *dataForstartDate;
    NSMutableData *webData;
    NSURLConnection *connection;
}

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    //initializing the arrays //
    
    dataForstartDate = [[NSMutableDictionary alloc] init];
    guideArray = [[NSMutableArray alloc] init];
    startDateArray = [[NSMutableArray alloc] init];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // link to get json contents of upcoming guides //
    
    NSURL *url = [NSURL URLWithString:@"https://www.guidebook.com/service/v2/upcomingGuides/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection){
        
        webData = [[NSMutableData alloc] init];
    }
    
    //this is to start the activity indicator //
    
    [self.aiv startAnimating];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"fail with error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // storing the objects from link into array
    NSArray *dataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    
    NSLog(@"Details are : %@",dataDictionary);
    
    NSArray *data = [dataDictionary valueForKey:@"data"];
    
    // each details of guide is added in guidelist
    for(int i =0;i<data.count;i++){
        Guide *guide = [[Guide alloc] init];
        
        guide.startDate = [[data objectAtIndex:i] objectForKey:@"startDate"];
        guide.endDate = [[data objectAtIndex:i] objectForKey:@"endDate"];
        guide.name = [[data objectAtIndex:i] objectForKey:@"name"];
        guide.image = [[data objectAtIndex:i] objectForKey:@"icon"];
        
        [guideArray addObject:guide];
        
    }
    
    // this step is to storing guidelist according to the start date //
    
    for(Guide *g in guideArray){
        NSString *currentstartdate = g.startDate;
        NSMutableArray *dataInstartDate = dataForstartDate[currentstartdate];
        
        if(! dataInstartDate)
        {
            [startDateArray addObject:currentstartdate];
            dataInstartDate = [NSMutableArray new];
            dataForstartDate[currentstartdate] = dataInstartDate;
        }
        [dataInstartDate addObject:g];
        
    }
    
    // this is to stop activity indicator view
    [self.aiv stopAnimating];
    [self.aiv hidesWhenStopped];
    
    [self.table reloadData];
    
    
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [startDateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSString *key = [startDateArray objectAtIndex:section];
    NSMutableArray *tableViewCellforSection = [dataForstartDate objectForKey:key];
    return [tableViewCellforSection count];
    
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [startDateArray objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    

    Guide *guideObject;
    
    NSString *startDate = startDateArray[indexPath.section];
    NSArray *details = dataForstartDate[startDate];
    guideObject = details[indexPath.row];
    
    //converting http link in the format of string to get image
    NSURL *imageURL = [NSURL URLWithString:guideObject.image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.imageView.image = image;
    cell.textLabel.text = guideObject.name;
    cell.detailTextLabel.text = [@"Ends - " stringByAppendingString:guideObject.endDate];
    
    
    return cell;
}

@end
