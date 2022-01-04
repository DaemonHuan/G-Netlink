//
//  NewDiagnosisReportBusiness.m
//  
//
//  Created by a95190 on 15/11/2.
//
//

#import "NewDiagnosisReportBusiness.h"

@implementation NewDiagnosisReportBusiness

-(id)init
{
    if(self = [super initWithNtspHeader]){
        self.businessId = BUSINESS_VEHICLE_DIAGNOSISREPORT;
        NSString *ip = API_ADDRESS;
        ip = [ip stringByAppendingString:@"system/diagnosis/query11"];
        self.baseBusinessHttpConnect.resquestType = HTTP_REQUEST_POST;
        self.baseBusinessHttpConnect.url = ip;
    }
    
    return self;
}

@end
