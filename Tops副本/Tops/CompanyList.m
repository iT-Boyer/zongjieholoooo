//
//  CompanyList.m
//  Tops
//
//  Created by Ding Sheng on 13-4-11.
//  Copyright (c) 2013年 鼎晟中天. All rights reserved.
//

#import "CompanyList.h"

#define POPOVER_WIDTH 120
#define POPOVER_HEIGHT 110
@interface CompanyList ()

@end

@implementation CompanyList

@synthesize stringsArray=_stringsArray;
@synthesize matchedStrings=_matchedStrings;
@synthesize popOver=_popOver;
@synthesize activeTextField=_activeTextField;

-(id)initWithArray:(NSArray *)array
{
    self=[super init];
    if (self) {
        self.stringsArray=array;
        self.matchedStrings=[NSArray array];
        
        //initializing PopOver
        self.popOver=[[[UIPopoverController alloc]initWithContentViewController:self]autorelease];
        self.popOver.popoverContentSize=CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
    }
    return self;
}

#pragma mark Main CompanyList Methods
-(void)matchStirng:(NSString *)letters
{
    self.matchedStrings=nil;
    if (_stringsArray==nil) {
        @throw [NSException exceptionWithName:@"Please set an array to stringsArray" reason:@"No array specified" userInfo:nil];
    }
    
    self.matchedStrings=[_stringsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith[cd] %@",letters]];
    [self.tableView reloadData];
}

-(void)showPopOverListFor:(UITextField*)textField
{
    UIPopoverArrowDirection arrowDirection=UIPopoverArrowDirectionAny;
    if ([self.matchedStrings count]==0) {
        [_popOver dismissPopoverAnimated:YES];
    }else if (!_popOver.isPopoverVisible){
        [_popOver presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:arrowDirection animated:YES];
    }
}

-(void)showCompanyListFor:(UITextField *)textField ShouldChangeCharactersInRange:(NSRange)rang replacementString:(NSString *)string
{
    NSMutableString *rightText;
    if (textField.text) {
        rightText=[NSMutableString stringWithString:textField.text];
        [rightText replaceCharactersInRange:rang
                                 withString:string];
    }else{
        rightText=[NSMutableString stringWithString:string];
    }
    
    [self matchStirng:rightText];
    [self showPopOverListFor:textField];
    self.activeTextField =textField;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.matchedStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    cell.textLabel.text=[self.matchedStrings objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.activeTextField setText:[self.matchedStrings objectAtIndex:indexPath.row]];
    [self.popOver dismissPopoverAnimated:YES];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)InterfaceOrientation
{
    return YES;
}

-(void)dealloc
{
    self.stringsArray=nil;
    self.matchedStrings=nil;
    self.popOver=nil;
    [super dealloc];
}

@end
