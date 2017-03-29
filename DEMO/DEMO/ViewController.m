//
//  ViewController.m
//  DEMO
//
//  Created by Songwen Ding on 9/12/16.
//  Copyright © 2016 DingSoung. All rights reserved.
//

#import "ViewController.h"
#import "DEMO-Swift.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<Class> *models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.models = @[
                    WhiteDotView.class,
                    DescartesView.class,
                    PieChartView.class,
                    //SunburstView.class,
                    OrbitView.class,
                    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count > 0 ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text =  NSStringFromClass(self.models[indexPath.row]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *vc = [[DetailViewController alloc] init];
    
    if ([self.models[indexPath.row] isSubclassOfClass:DescartesView.class]) {
        DescartesView *d = [[DescartesView alloc] init];
        d.animationDuration = 1.2;
        vc.detailView = d;
    }
    else if ([self.models[indexPath.row] isSubclassOfClass:WhiteDotView.class]) {
        WhiteDotView *d = [[WhiteDotView alloc] init];
        d.animationDuration = 120;
        d.dimension = 4;
        
        NSMutableArray *arrays = [[NSMutableArray alloc] init];
        for (NSInteger indexRow = 0; indexRow < 20; indexRow++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger indexColumn = 0; indexColumn < d.dimension; indexColumn++) {
                NSNumber *number = [NSNumber numberWithInt:(arc4random() % 3)];
                [array addObject:number];
            }
            [arrays addObject:array];
        }
        d.models = arrays;
        vc.detailView = d;
    }
    else if ([self.models[indexPath.row] isSubclassOfClass:PieChartView.class]) {
        PieChartView *d = [[PieChartView alloc] init];
        d.animationDuration = 0.8;
        vc.detailView = d;
    }
    /*
    else if ([self.models[indexPath.row] isSubclassOfClass:SunburstView.class]) {
        SunburstView *d = [[SunburstView alloc] init];
        d.animationDuration = 0.8;
        d.models = ({
            NSMutableArray<NSArray<SunburstModel *> *> *modelss = [[NSMutableArray alloc] init];
            for (int section = 0; section < 4; section++) {
                NSMutableArray<SunburstModel *> *models = [[NSMutableArray alloc] init];
                double start = 0;
                double size = 0;
                while (start < 95) {
                    size = [RadomData uInt:MIN(10, (100 - start))];
                    SunburstModel *model = [[SunburstModel alloc] initWithStart:start / 100.0 capacity: size / 100.0 color:nil title:nil];
                    [models addObject:model];
                    start += size;
                }
                [modelss addObject:models.copy];
            }
            modelss.copy;
        });
        for (NSArray<SunburstModel *> *section in d.models) {
            for (SunburstModel *row in section) {
                row.start *= 2 * M_PI;
                row.capacity *= 2 * M_PI;
                row.color = RadomData.color;
                row.title = [RadomData string:[RadomData uInt:8]];
                row.color = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1];
            }
        }
        vc.detailView = d;
    }*/
    else {
        vc.detailView = [[self.models[indexPath.row] alloc] init];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
