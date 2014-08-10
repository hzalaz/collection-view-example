//
//  InMemoryUserRepository.m
//  CollectionViewExample
//
//  Created by Guido Marucci Blas on 8/10/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "InMemoryProductRepository.h"
#import "ProductFactory.h"

NSError * productNotFoundError(NSString * productId) {
    NSDictionary * info = @{@"productId" : productId};
    return [NSError errorWithDomain:PRODUCT_REPOSITORY_ERROR_DOMAIN code:PRODUCT_NOT_FOUND userInfo:info];
}

@interface InMemoryProductRepository ()

@property(readonly, nonatomic) NSMutableDictionary * data;

@end

@implementation InMemoryProductRepository

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
        
        ProductFactory * factory = [ProductFactory sharedFactory];
        for (int i = 0; i < 10; ++i) {
            Product * product = [factory createProduct];
            self.data[product.productId] = product;
        }
    }
    return self;
}

#pragma mark - Repository Protocol Methods

- (void)fetchProductsWithHandler:(void(^)(NSError *, NSArray *))handler {
    __block typeof(self) this = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        handler(nil, [this.data allValues]);
    });
}

- (void)fetchById:(NSString *)productId withHandler:(void(^)(NSError *, Product *))handler {
    __block typeof(self) this = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Product * product = this.data[productId];
        if (product) {
            handler(nil, product);
        } else {
            handler(productNotFoundError(productId), nil);
        }
    });
}

- (void)favoriteProductWithId:(NSString *)productId withHandler:(void(^)(NSError *))handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        handler(nil);
    });
}


#pragma mark - In Memory Repository Methods

- (void)addProduct:(Product *)product {
    if (product.productId) {
        self.data[product.productId] = product;
    }
}

- (void)removeProduct:(Product *)product {
    [self removeProductWithId:product.productId];
}

- (void)removeProductWithId:(NSString *)productId {
    [self.data removeObjectForKey:productId];
}

@end