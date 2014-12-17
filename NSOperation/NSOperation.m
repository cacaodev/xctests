//
//  FoundationTestTests.m
//  FoundationTestTests
//
//  Created by Martin on 15/12/2014.
//  Copyright (c) 2014 Pear Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface NSOperationTest : XCTestCase

@end

@interface Operation : NSOperation
@property (assign) BOOL didStart;
@property (assign) BOOL didMain;
@end

@implementation NSOperationTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCancelledOperationDoesStartInQueue
{
    // This is an example of a functional test case.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    Operation *op = [[Operation alloc] init];
    
    XCTAssertFalse(op.isFinished);
    XCTAssertFalse(op.isCancelled);
    XCTAssertFalse(op.didStart);
    XCTAssertFalse(op.didMain);
    
    [op cancel];
    
    XCTAssertTrue(op.isCancelled);
    XCTAssertFalse(op.isFinished);
    
    [queue addOperations:@[op] waitUntilFinished:YES];
    
    XCTAssertTrue(op.isCancelled);
    XCTAssertTrue(op.isFinished);
    XCTAssertTrue(op.didStart);
    XCTAssertFalse(op.didMain);
}

- (void)testCancelledOperationIsFinishedAfterStart
{
    NSMutableArray *results = [NSMutableArray array];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^(void)
                            {
                                [results addObject:@"op"];
                            }];
    
    XCTAssertFalse(op.isCancelled);
    XCTAssertFalse(op.isFinished);
    
    [op cancel];
    
    XCTAssertTrue(op.isCancelled);
    XCTAssertFalse(op.isFinished);
    
    [op start];
    
    XCTAssertTrue(op.isCancelled);
    XCTAssertTrue(op.isFinished);
    XCTAssertTrue(results.count == 0);
}

@end

@implementation Operation
{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.didMain = NO;
        self.didStart = NO;
    }
    
    return self;
}

- (void)main
{
    self.didMain = YES;
}

- (void)start
{
    [super start];
    self.didStart = YES;
}

@end