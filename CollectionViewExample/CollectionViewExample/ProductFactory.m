//
//  ProductFactory.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "ProductFactory.h"
#import "NSArray+Random.h"

@interface ProductFactory ()

@property(nonatomic) NSArray * imageURLs;
@property(nonatomic) NSArray * names;
@property(nonatomic) NSArray * prices;

@end

@implementation ProductFactory

+ (instancetype)sharedFactory {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageURLs = @[
            @"http://www.botasdejugadores.com/wp-content/uploads/2014/03/nike-tiempo-legend-5-rojas-blancas-51.jpg",
            @"http://2.bp.blogspot.com/-R0T0bXmBCOE/UjbNV9n91aI/AAAAAAAAJHQ/nqg2eNQALZQ/s738/NikeTiempo-Legend-Hi-Vis-Boot-2.jpg"
        ];
        self.names = @[
            @"Botines Nike Tiempo",
            @"Botines Nike T90"
        ];
        self.prices = @[
            @(70000),
            @(54999)
        ];
    }
    return self;
}

- (Product *)createProduct {
    NSString * name = [self.names randomObject];
    NSUInteger price = [[self.prices randomObject] unsignedIntegerValue];
    NSURL * imageURL = [NSURL URLWithString:[self.imageURLs randomObject]];
    return [[Product alloc] initWithName:name price:price andImageURL:imageURL];
}

@end