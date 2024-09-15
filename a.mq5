//+------------------------------------------------------------------+
//|                                                 Eidii_mew_v2.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert Data Type Defenition                                      |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#define ORDER_NUMBER 150
#define SLIPPAGE     10
enum crossNames   //// enumeration of named constants 
   {
     EURUSD,
     USDJPY,
     GBPUSD,
     EURJPY,
     GBPJPY,
     USDCHF,
     GBPCHF,
     EURGBP,
     CHFJPY,
     AUDUSD,
     EURAUD,
     GBPAUD,
     GBPNZD,
     AUDCHF,
     AUDNZD,
     EURNZD,
     USDCAD,
     CADCHF,
     GBPCAD,
     CADJPY,
     EURCAD,
     AUDCAD,
     Null  
   };
   
enum tradeType   //// enumeration type of trade 
   {    
     BUY,
     SELL      
   };
///
input double    totalProfit  = 1;
input int       magic = 100; //magic number
//input double    negThereshold = -50;
input int       profitPercent = 10;
input int       pointTradeThereshold = 100;
input crossNames SYMBOL1_1    = 1;input tradeType  TypeTrade1_1 = 1;input double     VolTrade1_1  = 0.01;
input crossNames SYMBOL2_1    = 2;input tradeType  TypeTrade2_1 = 1;input double     VolTrade2_1  = 0.01;
input crossNames SYMBOL3_1    = 3;input tradeType  TypeTrade3_1 = 1;input double     VolTrade3_1  = 0.01;
input double     NegThershold_1 = -50;

input crossNames SYMBOL1_2    = 1;input tradeType  TypeTrade1_2 = 1;input double     VolTrade1_2  = 0.01;
input crossNames SYMBOL2_2    = 2;input tradeType  TypeTrade2_2 = 1;input double     VolTrade2_2  = 0.01;
input double     NegThershold_2 = -50;

input crossNames SYMBOL1_3 = 1;input tradeType  TypeTrade1_3 = 1;input double     VolTrade1_3  = 0.01;
input crossNames SYMBOL2_3 = 2;input tradeType  TypeTrade2_3 = 1;input double     VolTrade2_3  = 0.01;
input crossNames SYMBOL3_3 = 3;input tradeType  TypeTrade3_3 = 1;input double     VolTrade3_3  = 0.01;
input double     NegThershold_3 = -50;
input crossNames SYMBOL1_4 = 1;input tradeType  TypeTrade1_4 = 1;input double     VolTrade1_4  = 0.01;
input crossNames SYMBOL2_4 = 2;input tradeType  TypeTrade2_4 = 1;input double     VolTrade2_4  = 0.01;
input double     NegThershold_4 = -50;
input crossNames SYMBOL1_5 = 1;input tradeType  TypeTrade1_5 = 1;input double     VolTrade1_5  = 0.01;
input crossNames SYMBOL2_5 = 2;input tradeType  TypeTrade2_5 = 1;input double     VolTrade2_5  = 0.01;
input crossNames SYMBOL3_5 = 3;input tradeType  TypeTrade3_5 = 1;input double     VolTrade3_5  = 0.01;
input double     NegThershold_5 = -50;
input crossNames SYMBOL1_6 = 1;input tradeType  TypeTrade1_6 = 1;input double     VolTrade1_6  = 0.01;
input crossNames SYMBOL2_6 = 2;input tradeType  TypeTrade2_6 = 1;input double     VolTrade2_6  = 0.01;
input double     NegThershold_6 = -50;
input crossNames SYMBOL1_7 = 1;input tradeType  TypeTrade1_7 = 1;input double     VolTrade1_7  = 0.01;
input crossNames SYMBOL2_7 = 2;input tradeType  TypeTrade2_7 = 1;input double     VolTrade2_7  = 0.01;
input crossNames SYMBOL3_7 = 3;input tradeType  TypeTrade3_7 = 1;input double     VolTrade3_7  = 0.01;
input double     NegThershold_7 = -50;
input crossNames SYMBOL1_8 = 1;input tradeType  TypeTrade1_8 = 1;input double     VolTrade1_8  = 0.01;
input crossNames SYMBOL2_8 = 2;input tradeType  TypeTrade2_8 = 1;input double     VolTrade2_8  = 0.01;
input double     NegThershold_8 = -50;
input crossNames SYMBOL1_9 = 1;input tradeType  TypeTrade1_9 = 1;input double     VolTrade1_9  = 0.01;
input crossNames SYMBOL2_9 = 2;input tradeType  TypeTrade2_9 = 1;input double     VolTrade2_9  = 0.01;
input crossNames SYMBOL3_9 = 3;input tradeType  TypeTrade3_9 = 1;input double     VolTrade3_9  = 0.01;
input double     NegThershold_9 = -50;
input crossNames SYMBOL1_10 = 1;input tradeType  TypeTrade1_10 = 1;input double     VolTrade1_10  = 0.01;
input crossNames SYMBOL2_10 = 2;input tradeType  TypeTrade2_10 = 1;input double     VolTrade2_10  = 0.01;
input double     NegThershold_10 = -50;
input crossNames SYMBOL1_11 = 1;input tradeType  TypeTrade1_11 = 1;input double     VolTrade1_11  = 0.01;
input crossNames SYMBOL2_11 = 2;input tradeType  TypeTrade2_11 = 1;input double     VolTrade2_11  = 0.01;
input crossNames SYMBOL3_11 = 3;input tradeType  TypeTrade3_11 = 1;input double     VolTrade3_11  = 0.01;
input double     NegThershold_11 = -50;
input crossNames SYMBOL1_12 = 1;input tradeType  TypeTrade1_12 = 1;input double     VolTrade1_12  = 0.01;
input crossNames SYMBOL2_12 = 2;input tradeType  TypeTrade2_12 = 1;input double     VolTrade2_12  = 0.01;
input double     NegThershold_12 = -50;
input crossNames SYMBOL1_13 = 1;input tradeType  TypeTrade1_13 = 1;input double     VolTrade1_13  = 0.01;
input crossNames SYMBOL2_13 = 2;input tradeType  TypeTrade2_13 = 1;input double     VolTrade2_13  = 0.01;
input crossNames SYMBOL3_13 = 3;input tradeType  TypeTrade3_13 = 1;input double     VolTrade3_13  = 0.01;
input double     NegThershold_13 = -50;
input crossNames SYMBOL1_14 = 1;input tradeType  TypeTrade1_14 = 1;input double     VolTrade1_14  = 0.01;
input crossNames SYMBOL2_14 = 2;input tradeType  TypeTrade2_14 = 1;input double     VolTrade2_14  = 0.01;
input double     NegThershold_14 = -50;
input crossNames SYMBOL1_15 = 1;input tradeType  TypeTrade1_15 = 1;input double     VolTrade1_15  = 0.01;
input crossNames SYMBOL2_15 = 2;input tradeType  TypeTrade2_15 = 1;input double     VolTrade2_15  = 0.01;
input crossNames SYMBOL3_15 = 3;input tradeType  TypeTrade3_15 = 1;input double     VolTrade3_15  = 0.01;
input double     NegThershold_15 = -50;
input crossNames SYMBOL1_16 = 1;input tradeType  TypeTrade1_16 = 1;input double     VolTrade1_16  = 0.01;
input crossNames SYMBOL2_16 = 2;input tradeType  TypeTrade2_16 = 1;input double     VolTrade2_16  = 0.01;
input double     NegThershold_16 = -50;
input crossNames SYMBOL1_17 = 1;input tradeType  TypeTrade1_17 = 1;input double     VolTrade1_17  = 0.01;
input crossNames SYMBOL2_17 = 2;input tradeType  TypeTrade2_17 = 1;input double     VolTrade2_17  = 0.01;
input crossNames SYMBOL3_17 = 3;input tradeType  TypeTrade3_17 = 1;input double     VolTrade3_17  = 0.01;
input double     NegThershold_17 = -50;
input crossNames SYMBOL1_18 = 1;input tradeType  TypeTrade1_18 = 1;input double     VolTrade1_18  = 0.01;
input crossNames SYMBOL2_18 = 2;input tradeType  TypeTrade2_18 = 1;input double     VolTrade2_18  = 0.01;
input double     NegThershold_18 = -50;
input crossNames SYMBOL1_19 = 1;input tradeType  TypeTrade1_19 = 1;input double     VolTrade1_19  = 0.01;
input crossNames SYMBOL2_19 = 2;input tradeType  TypeTrade2_19 = 1;input double     VolTrade2_19  = 0.01;
input crossNames SYMBOL3_19 = 3;input tradeType  TypeTrade3_19 = 1;input double     VolTrade3_19  = 0.01;
input double     NegThershold_19 = -50;
input crossNames SYMBOL1_20 = 1;input tradeType  TypeTrade1_20 = 1;input double     VolTrade1_20  = 0.01;
input crossNames SYMBOL2_20 = 2;input tradeType  TypeTrade2_20 = 1;input double     VolTrade2_20  = 0.01;
input double     NegThershold_20 = -50;
input crossNames SYMBOL1_21 = 1;input tradeType  TypeTrade1_21 = 1;input double     VolTrade1_21  = 0.01;
input crossNames SYMBOL2_21 = 2;input tradeType  TypeTrade2_21 = 1;input double     VolTrade2_21  = 0.01;
input crossNames SYMBOL3_21 = 3;input tradeType  TypeTrade3_21 = 1;input double     VolTrade3_21  = 0.01;
input double     NegThershold_21 = -50;
input crossNames SYMBOL1_22 = 1;input tradeType  TypeTrade1_22= 1;input double     VolTrade1_22 = 0.01;
input crossNames SYMBOL2_22 = 2;input tradeType  TypeTrade2_22 = 1;input double     VolTrade2_22  = 0.01;
input double     NegThershold_22 = -50;
input crossNames SYMBOL1_23 = 1;input tradeType  TypeTrade1_23 = 1;input double     VolTrade1_23  = 0.01;
input crossNames SYMBOL2_23 = 2;input tradeType  TypeTrade2_23 = 1;input double     VolTrade2_23  = 0.01;
input crossNames SYMBOL3_23 = 3;input tradeType  TypeTrade3_23 = 1;input double     VolTrade3_23  = 0.01;
input double     NegThershold_23 = -50;
input crossNames SYMBOL1_24 = 1;input tradeType  TypeTrade1_24 = 1;input double     VolTrade1_24  = 0.01;
input crossNames SYMBOL2_24 = 2;input tradeType  TypeTrade2_24 = 1;input double     VolTrade2_24  = 0.01;
input double     NegThershold_24 = -50;

input crossNames SYMBOL1_25 = 1;input tradeType  TypeTrade1_25 = 1;input double     VolTrade1_25  = 0.01;
input crossNames SYMBOL2_25 = 2;input tradeType  TypeTrade2_25 = 1;input double     VolTrade2_25  = 0.01;
input crossNames SYMBOL3_25 = 3;input tradeType  TypeTrade3_25= 1;input double     VolTrade3_25  = 0.01;
input double     NegThershold_25 = -50;
input crossNames SYMBOL1_26 = 1;input tradeType  TypeTrade1_26 = 1;input double     VolTrade1_26  = 0.01;
input crossNames SYMBOL2_26 = 2;input tradeType  TypeTrade2_26 = 1;input double     VolTrade2_26  = 0.01;
input double     NegThershold_26 = -50;
input crossNames SYMBOL1_27 = 1;input tradeType  TypeTrade1_27 = 1;input double     VolTrade1_27  = 0.01;
input crossNames SYMBOL2_27 = 2;input tradeType  TypeTrade2_27 = 1;input double     VolTrade2_27  = 0.01;
input crossNames SYMBOL3_27 = 3;input tradeType  TypeTrade3_27 = 1;input double     VolTrade3_27  = 0.01;
input double     NegThershold_27 = -50;
input crossNames SYMBOL1_28 = 1;input tradeType  TypeTrade1_28 = 1;input double     VolTrade1_28  = 0.01;
input crossNames SYMBOL2_28 = 2;input tradeType  TypeTrade2_28 = 1;input double     VolTrade2_28  = 0.01;
input double     NegThershold_28 = -50;
input crossNames SYMBOL1_29 = 1;input tradeType  TypeTrade1_29 = 1;input double     VolTrade1_29  = 0.01;
input crossNames SYMBOL2_29 = 2;input tradeType  TypeTrade2_29 = 1;input double     VolTrade2_29  = 0.01;
input crossNames SYMBOL3_29 = 3;input tradeType  TypeTrade3_29 = 1;input double     VolTrade3_29  = 0.01;
input double     NegThershold_29 = -50;
input crossNames SYMBOL1_30 = 1;input tradeType  TypeTrade1_30 = 1;input double     VolTrade1_30  = 0.01;
input crossNames SYMBOL2_30 = 2;input tradeType  TypeTrade2_30 = 1;input double     VolTrade2_30  = 0.01;
input double     NegThershold_30 = -50;

input crossNames SYMBOL1_31 = 1;input tradeType  TypeTrade1_31 = 1;input double     VolTrade1_31  = 0.01;
input crossNames SYMBOL2_31 = 2;input tradeType  TypeTrade2_31 = 1;input double     VolTrade2_31  = 0.01;
input crossNames SYMBOL3_31 = 3;input tradeType  TypeTrade3_31 = 1;input double     VolTrade3_31  = 0.01;
input double     NegThershold_31 = -50;
input crossNames SYMBOL1_32 = 1;input tradeType  TypeTrade1_32 = 1;input double     VolTrade1_32  = 0.01;
input crossNames SYMBOL2_32 = 2;input tradeType  TypeTrade2_32 = 1;input double     VolTrade2_32  = 0.01;
input double     NegThershold_32 = -50;
input crossNames SYMBOL1_33 = 1;input tradeType  TypeTrade1_33 = 1;input double     VolTrade1_33  = 0.01;
input crossNames SYMBOL2_33 = 2;input tradeType  TypeTrade2_33 = 1;input double     VolTrade2_33  = 0.01;
input crossNames SYMBOL3_33 = 3;input tradeType  TypeTrade3_33 = 1;input double     VolTrade3_33  = 0.01;
input double     NegThershold_33 = -50;
input crossNames SYMBOL1_34 = 1;input tradeType  TypeTrade1_34 = 1;input double     VolTrade1_34  = 0.01;
input crossNames SYMBOL2_34 = 2;input tradeType  TypeTrade2_34 = 1;input double     VolTrade2_34  = 0.01;
input double     NegThershold_34 = -50;
input crossNames SYMBOL1_35 = 1;input tradeType  TypeTrade1_35 = 1;input double     VolTrade1_35  = 0.01;
input crossNames SYMBOL2_35 = 2;input tradeType  TypeTrade2_35 = 1;input double     VolTrade2_35  = 0.01;
input crossNames SYMBOL3_35 = 3;input tradeType  TypeTrade3_35 = 1;input double     VolTrade3_35  = 0.01;
input double     NegThershold_35 = -50;
input crossNames SYMBOL1_36 = 1;input tradeType  TypeTrade1_36 = 1;input double     VolTrade1_36  = 0.01;
input crossNames SYMBOL2_36 = 2;input tradeType  TypeTrade2_36 = 1;input double     VolTrade2_36  = 0.01;
input double     NegThershold_36 = -50;

input crossNames SYMBOL1_37 = 1;input tradeType  TypeTrade1_37 = 1;input double     VolTrade1_37  = 0.01;
input crossNames SYMBOL2_37 = 2;input tradeType  TypeTrade2_37 = 1;input double     VolTrade2_37  = 0.01;
input crossNames SYMBOL3_37 = 3;input tradeType  TypeTrade3_37 = 1;input double     VolTrade3_37  = 0.01;
input double     NegThershold_37 = -50;
input crossNames SYMBOL1_38 = 1;input tradeType  TypeTrade1_38 = 1;input double     VolTrade1_38  = 0.01;
input crossNames SYMBOL2_38 = 2;input tradeType  TypeTrade2_38 = 1;input double     VolTrade2_38  = 0.01;
input double     NegThershold_38 = -50;
input crossNames SYMBOL1_39 = 1;input tradeType  TypeTrade1_39 = 1;input double     VolTrade1_39  = 0.01;
input crossNames SYMBOL2_39 = 2;input tradeType  TypeTrade2_39 = 1;input double     VolTrade2_39  = 0.01;
input crossNames SYMBOL3_39 = 3;input tradeType  TypeTrade3_39 = 1;input double     VolTrade3_39  = 0.01;
input double     NegThershold_39 = -50;
input crossNames SYMBOL1_40 = 1;input tradeType  TypeTrade1_40 = 1;input double     VolTrade1_40  = 0.01;
input crossNames SYMBOL2_40 = 2;input tradeType  TypeTrade2_40 = 1;input double     VolTrade2_40  = 0.01;
input double     NegThershold_40 = -50;
input crossNames SYMBOL1_41 = 1;input tradeType  TypeTrade1_41 = 1;input double     VolTrade1_41  = 0.01;
input crossNames SYMBOL2_41 = 2;input tradeType  TypeTrade2_41 = 1;input double     VolTrade2_41  = 0.01;
input crossNames SYMBOL3_41 = 3;input tradeType  TypeTrade3_41 = 1;input double     VolTrade3_41  = 0.01;
input double     NegThershold_41 = -50;
input crossNames SYMBOL1_42 = 1;input tradeType  TypeTrade1_42 = 1;input double     VolTrade1_42  = 0.01;
input crossNames SYMBOL2_42 = 2;input tradeType  TypeTrade2_42 = 1;input double     VolTrade2_42  = 0.01;
input double     NegThershold_42 = -50;

input crossNames SYMBOL1_43 = 1;input tradeType  TypeTrade1_43 = 1;input double     VolTrade1_43  = 0.01;
input crossNames SYMBOL2_43 = 2;input tradeType  TypeTrade2_43 = 1;input double     VolTrade2_43  = 0.01;
input crossNames SYMBOL3_43 = 3;input tradeType  TypeTrade3_43 = 1;input double     VolTrade3_43  = 0.01;
input double     NegThershold_43 = -50;
input crossNames SYMBOL1_44 = 1;input tradeType  TypeTrade1_44 = 1;input double     VolTrade1_44  = 0.01;
input crossNames SYMBOL2_44 = 2;input tradeType  TypeTrade2_44 = 1;input double     VolTrade2_44  = 0.01;
input double     NegThershold_44 = -50;
input crossNames SYMBOL1_45 = 1;input tradeType  TypeTrade1_45 = 1;input double     VolTrade1_45  = 0.01;
input crossNames SYMBOL2_45 = 2;input tradeType  TypeTrade2_45 = 1;input double     VolTrade2_45  = 0.01;
input double     NegThershold_45 = -50;
input crossNames SYMBOL3_45 = 3;input tradeType  TypeTrade3_45 = 1;input double     VolTrade3_45 = 0.01;
input crossNames SYMBOL1_46 = 1;input tradeType  TypeTrade1_46 = 1;input double     VolTrade1_46  = 0.01;
input crossNames SYMBOL2_46 = 2;input tradeType  TypeTrade2_46 = 1;input double     VolTrade2_46  = 0.01;
input double     NegThershold_46 = -50;
input crossNames SYMBOL1_47 = 1;input tradeType  TypeTrade1_47 = 1;input double     VolTrade1_47  = 0.01;
input crossNames SYMBOL2_47 = 2;input tradeType  TypeTrade2_47 = 1;input double     VolTrade2_47  = 0.01;
input crossNames SYMBOL3_47 = 3;input tradeType  TypeTrade3_47 = 1;input double     VolTrade3_47  = 0.01;
input double     NegThershold_47 = -50;
input crossNames SYMBOL1_48 = 1;input tradeType  TypeTrade1_48 = 1;input double     VolTrade1_48  = 0.01;
input crossNames SYMBOL2_48 = 2;input tradeType  TypeTrade2_48 = 1;input double     VolTrade2_48  = 0.01;
input double     NegThershold_48 = -50;
input crossNames SYMBOL1_49 = 1;input tradeType  TypeTrade1_49 = 1;input double     VolTrade1_49  = 0.01;
input crossNames SYMBOL2_49 = 2;input tradeType  TypeTrade2_49 = 1;input double     VolTrade2_49  = 0.01;
input crossNames SYMBOL3_49 = 3;input tradeType  TypeTrade3_49 = 1;input double     VolTrade3_49  = 0.01;
input double     NegThershold_49 = -50;
input crossNames SYMBOL1_50 = 1;input tradeType  TypeTrade1_50 = 1;input double     VolTrade1_50  = 0.01;
input crossNames SYMBOL2_50 = 2;input tradeType  TypeTrade2_50 = 1;input double     VolTrade2_50  = 0.01;
input double     NegThershold_50 = -50;
input int StopTime   =23;
input int StartTime  =2;
//order form varaibles
string  symbolOrder[ORDER_NUMBER];
string  orderComment[ORDER_NUMBER];
double  volOrder[ORDER_NUMBER];
int     typeOrder[ORDER_NUMBER];
int     baseTickets[ORDER_NUMBER];
double  levelDiff[ORDER_NUMBER];
double  negThershold[ORDER_NUMBER];
double  totalPrft;
CTrade tradeObj;
//

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
symbolOrder[0] = EnumToString(SYMBOL1_1) ;typeOrder[0] =   TypeTrade1_1 ;volOrder[0] =      VolTrade1_1  ;
symbolOrder[1] = EnumToString(SYMBOL2_1) ;typeOrder[1] =   TypeTrade2_1 ;volOrder[1] =      VolTrade2_1  ;
symbolOrder[2] = EnumToString(SYMBOL3_1) ;typeOrder[2] =   TypeTrade3_1 ;volOrder[2] =      VolTrade3_1  ;
negThershold[0] = NegThershold_1;

symbolOrder[3] = EnumToString(SYMBOL1_2 );typeOrder[3] =   TypeTrade1_2 ;volOrder[3] =      VolTrade1_2  ;
symbolOrder[4] = EnumToString(SYMBOL2_2 );typeOrder[4] =   TypeTrade2_2 ;volOrder[4] =      VolTrade2_2  ;
negThershold[1] = NegThershold_2;

symbolOrder[5] = EnumToString(SYMBOL1_3 );typeOrder[5] =   TypeTrade1_3 ;volOrder[5] =      VolTrade1_3  ;
symbolOrder[6] = EnumToString(SYMBOL2_3);typeOrder[6] =   TypeTrade2_3 ;volOrder[6] =      VolTrade2_3  ;
symbolOrder[7] = EnumToString(SYMBOL3_3);typeOrder[7] =   TypeTrade3_3 ;volOrder[7] =      VolTrade3_3  ;
negThershold[2] = NegThershold_3;
symbolOrder[8] = EnumToString(SYMBOL1_4 );typeOrder[8] =   TypeTrade1_4 ;volOrder[8] =      VolTrade1_4  ;
symbolOrder[9] = EnumToString(SYMBOL2_4);typeOrder[9] =   TypeTrade2_4 ;volOrder[9] =      VolTrade2_4  ;
negThershold[3] = NegThershold_4;
symbolOrder[10] = EnumToString(SYMBOL1_5 );typeOrder[10] =   TypeTrade1_5 ;volOrder[10] =      VolTrade1_5  ;
symbolOrder[11] = EnumToString(SYMBOL2_5);typeOrder[11] =   TypeTrade2_5 ;volOrder[11] =      VolTrade2_5  ;
symbolOrder[12] = EnumToString(SYMBOL3_5);typeOrder[12] =   TypeTrade3_5 ;volOrder[12] =      VolTrade3_5  ;
negThershold[4] = NegThershold_5;
symbolOrder[13] = EnumToString(SYMBOL1_6);typeOrder[13] =   TypeTrade1_6 ;volOrder[13] =      VolTrade1_6  ;
symbolOrder[14] = EnumToString(SYMBOL2_6);typeOrder[14] =   TypeTrade2_6 ;volOrder[14] =      VolTrade2_6  ;
negThershold[5] = NegThershold_6;

symbolOrder[15] = EnumToString(SYMBOL1_7 );typeOrder[15] =   TypeTrade1_7 ;volOrder[15] =      VolTrade1_7  ;
symbolOrder[16] = EnumToString(SYMBOL2_7);typeOrder[16] =   TypeTrade2_7 ;volOrder[16] =      VolTrade2_7  ;
symbolOrder[17] = EnumToString(SYMBOL3_7);typeOrder[17] =   TypeTrade3_7 ;volOrder[17] =      VolTrade3_7  ;
negThershold[6] = NegThershold_7;
symbolOrder[18] = EnumToString(SYMBOL1_8);typeOrder[18] =   TypeTrade1_8 ;volOrder[18] =      VolTrade1_8  ;
symbolOrder[19] = EnumToString(SYMBOL2_8);typeOrder[19] =   TypeTrade2_8 ;volOrder[19] =      VolTrade2_8  ;
negThershold[7] = NegThershold_8;
symbolOrder[20] = EnumToString(SYMBOL1_9 );typeOrder[20] =   TypeTrade1_9 ;volOrder[20] =      VolTrade1_9  ;
symbolOrder[21] = EnumToString(SYMBOL2_9);typeOrder[21] =   TypeTrade2_9 ;volOrder[21] =      VolTrade2_9  ;
symbolOrder[22] = EnumToString(SYMBOL3_9);typeOrder[22] =   TypeTrade3_9 ;volOrder[22] =      VolTrade3_9  ;
negThershold[8] = NegThershold_9;
symbolOrder[23] = EnumToString(SYMBOL1_10 );typeOrder[23] =   TypeTrade1_10 ;volOrder[23] =      VolTrade1_10  ;
symbolOrder[24] = EnumToString(SYMBOL2_10);typeOrder[24] =   TypeTrade2_10 ;volOrder[24] =      VolTrade2_10  ;
negThershold[9] = NegThershold_10;
symbolOrder[25] = EnumToString(SYMBOL1_11 );typeOrder[25] =   TypeTrade1_11 ;volOrder[25] =      VolTrade1_11  ;
symbolOrder[26] = EnumToString(SYMBOL2_11);typeOrder[26] =   TypeTrade2_11 ;volOrder[26] =      VolTrade2_11  ;
symbolOrder[27] = EnumToString(SYMBOL3_11);typeOrder[27] =   TypeTrade3_11 ;volOrder[27] =      VolTrade3_11  ;
negThershold[10] = NegThershold_11;
symbolOrder[28] = EnumToString(SYMBOL1_12 );typeOrder[28] =   TypeTrade1_12 ;volOrder[28] =      VolTrade1_12  ;
symbolOrder[29] = EnumToString(SYMBOL2_12);typeOrder[29] =   TypeTrade2_12 ;volOrder[29] =      VolTrade2_12  ;
negThershold[11] = NegThershold_12;
symbolOrder[30] = EnumToString(SYMBOL1_13 );typeOrder[30] =   TypeTrade1_13 ;volOrder[30] =      VolTrade1_13  ;
symbolOrder[31] = EnumToString(SYMBOL2_13);typeOrder[31] =   TypeTrade2_13 ;volOrder[31] =      VolTrade2_13  ;
symbolOrder[32] = EnumToString(SYMBOL3_13);typeOrder[32] =   TypeTrade3_13 ;volOrder[32] =      VolTrade3_13  ;
negThershold[12] = NegThershold_13;
symbolOrder[33] = EnumToString(SYMBOL1_14);typeOrder[33] =   TypeTrade1_14 ;volOrder[33] =      VolTrade1_14  ;
symbolOrder[34] = EnumToString(SYMBOL2_14);typeOrder[34] =   TypeTrade2_14 ;volOrder[34] =      VolTrade2_14  ;
negThershold[13] = NegThershold_14;
symbolOrder[35] = EnumToString(SYMBOL1_15);typeOrder[35] =   TypeTrade1_15 ;volOrder[35] =      VolTrade1_15  ;
symbolOrder[36] = EnumToString(SYMBOL2_15);typeOrder[36] =   TypeTrade2_15 ;volOrder[36] =      VolTrade2_15  ;
symbolOrder[37] = EnumToString(SYMBOL3_15);typeOrder[37] =   TypeTrade3_15 ;volOrder[37] =      VolTrade3_15  ;
negThershold[14] = NegThershold_15;
symbolOrder[38] = EnumToString(SYMBOL1_16);typeOrder[38] =   TypeTrade1_16 ;volOrder[38] =      VolTrade1_16  ;
symbolOrder[39] = EnumToString(SYMBOL2_16);typeOrder[39] =   TypeTrade2_16 ;volOrder[39] =      VolTrade2_16  ;
negThershold[15] = NegThershold_16;
symbolOrder[40] = EnumToString(SYMBOL1_17 );typeOrder[40] =   TypeTrade1_17 ;volOrder[40] =      VolTrade1_17  ;
symbolOrder[41] = EnumToString(SYMBOL2_17);typeOrder[41] =   TypeTrade2_17 ;volOrder[41] =      VolTrade2_17  ;
symbolOrder[42] = EnumToString(SYMBOL3_17);typeOrder[42] =   TypeTrade3_17 ;volOrder[42] =      VolTrade3_17  ;
negThershold[16] = NegThershold_17;
symbolOrder[43] = EnumToString(SYMBOL1_18);typeOrder[43] =   TypeTrade1_18 ;volOrder[43] =      VolTrade1_18  ;
symbolOrder[44] = EnumToString(SYMBOL2_18);typeOrder[44] =   TypeTrade2_18 ;volOrder[44] =      VolTrade2_18  ;
negThershold[17] = NegThershold_18;
symbolOrder[45] = EnumToString(SYMBOL1_19 );typeOrder[45] =   TypeTrade1_19 ;volOrder[45] =      VolTrade1_19  ;
symbolOrder[46] = EnumToString(SYMBOL2_19);typeOrder[46] =   TypeTrade2_19 ;volOrder[46] =      VolTrade2_19  ;
symbolOrder[47] = EnumToString(SYMBOL3_19);typeOrder[47] =   TypeTrade3_19 ;volOrder[47] =      VolTrade3_19  ;
negThershold[18] = NegThershold_19;
symbolOrder[48] = EnumToString(SYMBOL1_20 );typeOrder[48] =   TypeTrade1_20 ;volOrder[48] =      VolTrade1_20  ;
symbolOrder[49] = EnumToString(SYMBOL2_20);typeOrder[49] =   TypeTrade2_20 ;volOrder[49] =      VolTrade2_20  ;
negThershold[19] = NegThershold_20;
symbolOrder[50] = EnumToString(SYMBOL1_21);typeOrder[50] =   TypeTrade1_21 ;volOrder[50] =      VolTrade1_21  ;
symbolOrder[51] = EnumToString(SYMBOL2_21);typeOrder[51] =   TypeTrade2_21 ;volOrder[51] =      VolTrade2_21  ;
symbolOrder[52] = EnumToString(SYMBOL3_21);typeOrder[52] =   TypeTrade3_21 ;volOrder[52] =      VolTrade3_21  ;
negThershold[20] = NegThershold_21;
symbolOrder[53] = EnumToString(SYMBOL1_22 );typeOrder[53] =   TypeTrade1_22;volOrder[53] =      VolTrade1_22 ;
symbolOrder[54] = EnumToString(SYMBOL2_22);typeOrder[54] =   TypeTrade2_22 ;volOrder[54] =      VolTrade2_22  ;
negThershold[21] = NegThershold_22;
symbolOrder[55] = EnumToString(SYMBOL1_23 );typeOrder[55] =   TypeTrade1_23 ;volOrder[55] =      VolTrade1_23  ;
symbolOrder[56] = EnumToString(SYMBOL2_23);typeOrder[56] =   TypeTrade2_23 ;volOrder[56] =      VolTrade2_23  ;
symbolOrder[57] = EnumToString(SYMBOL3_23);typeOrder[57] =   TypeTrade3_23 ;volOrder[57] =      VolTrade3_23  ;
negThershold[22] = NegThershold_23;
symbolOrder[58] = EnumToString(SYMBOL1_24 );typeOrder[58] =   TypeTrade1_24 ;volOrder[58] =      VolTrade1_24  ;
symbolOrder[59] = EnumToString(SYMBOL2_24);typeOrder[59] =   TypeTrade2_24 ;volOrder[59] =      VolTrade2_24  ;
negThershold[23] = NegThershold_24;
symbolOrder[60] = EnumToString(SYMBOL1_25 );typeOrder[60] =   TypeTrade1_25 ;volOrder[60] =      VolTrade1_25  ;
symbolOrder[61] = EnumToString(SYMBOL2_25);typeOrder[61] =   TypeTrade2_25 ;volOrder[61] =      VolTrade2_25  ;
symbolOrder[62] = EnumToString(SYMBOL3_25);typeOrder[62] =   TypeTrade3_25;volOrder[62] =      VolTrade3_25  ;
negThershold[24] = NegThershold_25;
symbolOrder[63] = EnumToString(SYMBOL1_26);typeOrder[63] =   TypeTrade1_26 ;volOrder[63] =      VolTrade1_26  ;
symbolOrder[64] = EnumToString(SYMBOL2_26);typeOrder[64] =   TypeTrade2_26 ;volOrder[64] =      VolTrade2_26  ;
negThershold[25] = NegThershold_26;
symbolOrder[65] = EnumToString(SYMBOL1_27);typeOrder[65] =   TypeTrade1_27 ;volOrder[65] =      VolTrade1_27  ;
symbolOrder[66] = EnumToString(SYMBOL2_27);typeOrder[66] =   TypeTrade2_27 ;volOrder[66] =      VolTrade2_27  ;
symbolOrder[67] = EnumToString(SYMBOL3_27);typeOrder[67] =   TypeTrade3_27 ;volOrder[67] =      VolTrade3_27  ;
negThershold[26] = NegThershold_27;
symbolOrder[68] = EnumToString(SYMBOL1_28);typeOrder[68] =   TypeTrade1_28 ;volOrder[68] =      VolTrade1_28  ;
symbolOrder[69] = EnumToString(SYMBOL2_28);typeOrder[69] =   TypeTrade2_28 ;volOrder[69] =      VolTrade2_28  ;
negThershold[27] = NegThershold_28;
symbolOrder[70] = EnumToString(SYMBOL1_29);typeOrder[70] =   TypeTrade1_29 ;volOrder[70] =      VolTrade1_29  ;
symbolOrder[71] = EnumToString(SYMBOL2_29);typeOrder[71] =   TypeTrade2_29 ;volOrder[71] =      VolTrade2_29  ;
symbolOrder[72] = EnumToString(SYMBOL3_29);typeOrder[72] =   TypeTrade3_29 ;volOrder[72] =      VolTrade3_29  ;
negThershold[28] = NegThershold_29;
symbolOrder[73] = EnumToString(SYMBOL1_30);typeOrder[73] =   TypeTrade1_30 ;volOrder[73] =      VolTrade1_30  ;
symbolOrder[74] = EnumToString(SYMBOL2_30);typeOrder[74] =   TypeTrade2_30 ;volOrder[74] =      VolTrade2_30  ;
negThershold[29] = NegThershold_30;
symbolOrder[75] = EnumToString(SYMBOL1_31);typeOrder[75] =   TypeTrade1_31 ;volOrder[75] =      VolTrade1_31  ;
symbolOrder[76] = EnumToString(SYMBOL2_31);typeOrder[76] =   TypeTrade2_31 ;volOrder[76] =      VolTrade2_31  ;
symbolOrder[77] = EnumToString(SYMBOL3_31);typeOrder[77] =   TypeTrade3_31 ;volOrder[77] =      VolTrade3_31  ;
negThershold[30] = NegThershold_31;
symbolOrder[78] = EnumToString(SYMBOL1_32);typeOrder[78] =   TypeTrade1_32 ;volOrder[78] =      VolTrade1_32  ;
symbolOrder[79] = EnumToString(SYMBOL2_32);typeOrder[79] =   TypeTrade2_32 ;volOrder[79] =      VolTrade2_32  ;
negThershold[31] = NegThershold_32;
symbolOrder[80] = EnumToString(SYMBOL1_33);typeOrder[80] =   TypeTrade1_33 ;volOrder[80] =      VolTrade1_33  ;
symbolOrder[81] = EnumToString(SYMBOL2_33);typeOrder[81] =   TypeTrade2_33 ;volOrder[81] =      VolTrade2_33  ;
symbolOrder[82] = EnumToString(SYMBOL3_33);typeOrder[82] =   TypeTrade3_33 ;volOrder[82] =      VolTrade3_33  ;
negThershold[32] = NegThershold_33;
symbolOrder[83] = EnumToString(SYMBOL1_34);typeOrder[83] =   TypeTrade1_34 ;volOrder[83] =      VolTrade1_34  ;
symbolOrder[84] = EnumToString(SYMBOL2_34);typeOrder[84] =   TypeTrade2_34 ;volOrder[84] =      VolTrade2_34  ;
negThershold[33] = NegThershold_34;
symbolOrder[85] = EnumToString(SYMBOL1_35);typeOrder[85] =   TypeTrade1_35 ;volOrder[85] =      VolTrade1_35  ;
symbolOrder[86] = EnumToString(SYMBOL2_35);typeOrder[86] =   TypeTrade2_35 ;volOrder[86] =      VolTrade2_35  ;
symbolOrder[87] = EnumToString(SYMBOL3_35);typeOrder[87] =   TypeTrade3_35 ;volOrder[87] =      VolTrade3_35  ;
negThershold[34] = NegThershold_35;
symbolOrder[88] = EnumToString(SYMBOL1_36);typeOrder[88] =   TypeTrade1_36 ;volOrder[88] =      VolTrade1_36  ;
symbolOrder[89] = EnumToString(SYMBOL2_36);typeOrder[89] =   TypeTrade2_36 ;volOrder[89] =      VolTrade2_36  ;
negThershold[35] = NegThershold_36;
symbolOrder[90] = EnumToString(SYMBOL1_37);typeOrder[90] =   TypeTrade1_37 ;volOrder[90] =      VolTrade1_37  ;
symbolOrder[91] = EnumToString(SYMBOL2_37);typeOrder[91] =   TypeTrade2_37 ;volOrder[91] =      VolTrade2_37  ;
symbolOrder[92] = EnumToString(SYMBOL3_37);typeOrder[92] =   TypeTrade3_37 ;volOrder[92] =      VolTrade3_37  ;
negThershold[36] = NegThershold_37;
symbolOrder[93] = EnumToString(SYMBOL1_38);typeOrder[93] =   TypeTrade1_38 ;volOrder[93] =      VolTrade1_38  ;
symbolOrder[94] = EnumToString(SYMBOL2_38);typeOrder[94] =   TypeTrade2_38 ;volOrder[94] =      VolTrade2_38  ;
negThershold[37] = NegThershold_38;
symbolOrder[95] = EnumToString(SYMBOL1_39);typeOrder[95] =   TypeTrade1_39 ;volOrder[95] =      VolTrade1_39  ;
symbolOrder[96] = EnumToString(SYMBOL2_39);typeOrder[96] =   TypeTrade2_39 ;volOrder[96] =      VolTrade2_39  ;
symbolOrder[97] = EnumToString(SYMBOL3_39);typeOrder[97] =   TypeTrade3_39 ;volOrder[97] =      VolTrade3_39  ;
negThershold[38] = NegThershold_39;
symbolOrder[98] = EnumToString(SYMBOL1_40);typeOrder[98] =   TypeTrade1_40 ;volOrder[98] =      VolTrade1_40  ;
symbolOrder[99] = EnumToString(SYMBOL2_40);typeOrder[99] =   TypeTrade2_40 ;volOrder[99] =      VolTrade2_40  ;
negThershold[39] = NegThershold_40;
symbolOrder[100] = EnumToString(SYMBOL1_41);typeOrder[100] =   TypeTrade1_41 ;volOrder[100] =      VolTrade1_41  ;
symbolOrder[101] = EnumToString(SYMBOL2_41);typeOrder[101] =   TypeTrade2_41 ;volOrder[101] =      VolTrade2_41  ;
symbolOrder[102] = EnumToString(SYMBOL3_41);typeOrder[102] =   TypeTrade3_41 ;volOrder[102] =      VolTrade3_41  ;
negThershold[40] = NegThershold_41;
symbolOrder[103] = EnumToString(SYMBOL1_42);typeOrder[103] =   TypeTrade1_42 ;volOrder[103] =      VolTrade1_42  ;
symbolOrder[104] = EnumToString(SYMBOL2_42);typeOrder[104] =   TypeTrade2_42 ;volOrder[104] =      VolTrade2_42  ;
negThershold[41] = NegThershold_42;
symbolOrder[105] = EnumToString(SYMBOL1_43);typeOrder[105] =   TypeTrade1_43 ;volOrder[105] =      VolTrade1_43  ;
symbolOrder[106] = EnumToString(SYMBOL2_43);typeOrder[106] =   TypeTrade2_43 ;volOrder[106] =      VolTrade2_43  ;
symbolOrder[107] = EnumToString(SYMBOL3_43);typeOrder[107] =   TypeTrade3_43 ;volOrder[107] =      VolTrade3_43  ;
negThershold[42] = NegThershold_43;
symbolOrder[108] = EnumToString(SYMBOL1_44);typeOrder[108] =   TypeTrade1_44 ;volOrder[108] =      VolTrade1_44  ;
symbolOrder[109] = EnumToString(SYMBOL2_44);typeOrder[109] =   TypeTrade2_44 ;volOrder[109] =      VolTrade2_44  ;
negThershold[43] = NegThershold_44;
symbolOrder[110] = EnumToString(SYMBOL1_45);typeOrder[110] =   TypeTrade1_45 ;volOrder[110] =      VolTrade1_45  ;
symbolOrder[111] = EnumToString(SYMBOL2_45);typeOrder[111] =   TypeTrade2_45 ;volOrder[111] =      VolTrade2_45  ;
symbolOrder[112] = EnumToString(SYMBOL3_45);typeOrder[112] =   TypeTrade3_45 ;volOrder[112] =      VolTrade3_45 ;
negThershold[44] = NegThershold_45;
symbolOrder[113] = EnumToString(SYMBOL1_46);typeOrder[113] =   TypeTrade1_46 ;volOrder[113] =      VolTrade1_46  ;
symbolOrder[114] = EnumToString(SYMBOL2_46);typeOrder[114] =   TypeTrade2_46 ;volOrder[114] =      VolTrade2_46  ;
negThershold[45] = NegThershold_46;
symbolOrder[115] = EnumToString(SYMBOL1_47);typeOrder[115] =   TypeTrade1_47 ;volOrder[115] =      VolTrade1_47  ;
symbolOrder[116] = EnumToString(SYMBOL2_47);typeOrder[116] =   TypeTrade2_47 ;volOrder[116] =      VolTrade2_47  ;
symbolOrder[117] = EnumToString(SYMBOL3_47);typeOrder[117] =   TypeTrade3_47 ;volOrder[117] =      VolTrade3_47  ;
negThershold[46] = NegThershold_47;
symbolOrder[118] = EnumToString(SYMBOL1_48);typeOrder[118] =   TypeTrade1_48 ;volOrder[118] =      VolTrade1_48  ;
symbolOrder[119] = EnumToString(SYMBOL2_48);typeOrder[119] =   TypeTrade2_48 ;volOrder[119] =      VolTrade2_48  ;
negThershold[47] = NegThershold_48;
symbolOrder[120] = EnumToString(SYMBOL1_49);typeOrder[120] =   TypeTrade1_49 ;volOrder[120] =      VolTrade1_49  ;
symbolOrder[121] = EnumToString(SYMBOL2_49);typeOrder[121] =   TypeTrade2_49 ;volOrder[121] =      VolTrade2_49  ;
symbolOrder[122] = EnumToString(SYMBOL3_49);typeOrder[122] =   TypeTrade3_49 ;volOrder[122] =      VolTrade3_49  ;
negThershold[48] = NegThershold_49;
symbolOrder[123] = EnumToString(SYMBOL1_50);typeOrder[123] =   TypeTrade1_50 ;volOrder[123] =      VolTrade1_50  ;
symbolOrder[124] = EnumToString(SYMBOL2_50);typeOrder[124] =   TypeTrade2_50 ;volOrder[124] =      VolTrade2_50  ;
negThershold[49] = NegThershold_50;
totalPrft = totalProfit;
//
   
///////
   if(!checkSpread(1))
        PrintFormat("levelTrade Wide Spread Error =");    
   levelTrade(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   MqlDateTime T;
static int level = 1;

while(1){
   TimeCurrent(T);

   if (totalProfitCal()>= totalPrft || PositionsTotal()==0&&T.hour<=StopTime&&T.hour>=StartTime){
         if(!closeAllPosition()){
           PrintFormat("Colse All Error = %d",GetLastError());
           while(1);
           }else if(checkSpread(1)){
                   if(!levelTrade(1)){
                    PrintFormat("level0Trade Error = %d",GetLastError());              
                   }else {
                      level = 1;
                      totalPrft = totalProfit;
                      break;
                   }
           }else break;
           }
     
if(
    ((negThershold[level-1] < 0 && spaceCal(level) < (negThershold[level-1] / 10000)) || // Check for loss if negThershold is negative
     (negThershold[level-1] > 0 && spaceCal(level) > (negThershold[level-1] / 10000))) && // Check for profit if negThershold is positive
    checkSpread(level) && // Check if the spread is acceptable
    T.hour <= StopTime && T.hour >= StartTime // Ensure the current time is within trading hours
   )
{
    totalPrft = totalPrft + totalPrft * profitPercent / 100;  // Increase the total profit by profitPercent
    level++;  // Move to the next level
    levelTrade(level);  // Execute a new trade at the next level
}

   break;
   
}
   
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Total profit calculator Function                                 |
//+------------------------------------------------------------------+
double totalProfitCal(void){
   
  double totalPrf=0; 
  int k  = PositionsTotal()-1;
  
  for(k;k>=0;--k){
      if(!PositionSelectByTicket(PositionGetTicket(k))){
         PrintFormat("Position Close Error = %d",GetLastError());
      }
     totalPrf += PositionGetDouble(POSITION_PROFIT);//+PositionGetDouble(POSITION_SWAP);//+PositionGetDouble(PO); //*********//commision is omited 
  }
  return totalPrf;

}

//+------------------------------------------------------------------+
//| Level0 Trade Function                                            |
//+------------------------------------------------------------------+
bool levelTrade(int level){     
  
   string tempComment;
   double price;
   int  i,t=0,num=0,count;
   if (MathMod(level,2) ==0){
      num = 2;
      count = (level/2)*3+((level/2)-1)*2; 
   }
   else{ 
      num = 3;
      count = (level/2)*3+(level/2)*2; 
     }
       for(i=count;i<(count+num);i++){  
          tradeObj.SetExpertMagicNumber(magic); 
          switch(typeOrder[i]){
            case 0: //order buy
                 tempComment = symbolOrder[i]; 
                if(!tradeObj.Buy(volOrder[i],symbolOrder[i],0,0,0,IntegerToString(level))){
                   Print("OrderClose returned the error of ",GetLastError());
                   return(false);
              }
                 
            break;
            case 1: //order sell
               tempComment = symbolOrder[i];
              //  price = SymbolInfoDouble(symbolOrder[i],SYMBOL_ASK); 
               if(!tradeObj.Sell(volOrder[i],symbolOrder[i],0,0,0,IntegerToString(level))){
                     Print("OrderClose returned the error of ",GetLastError());
                     return(false);
                }
        
            break;  
          }
        
         baseTickets[i] = PositionGetTicket(PositionsTotal()-1);
         
      }
      return(true);   
 
  }
  
  


//+------------------------------------------------------------------+
//| Close All Position function                                      |
//+------------------------------------------------------------------+
bool closeAllPosition(void){
int k =PositionsTotal()-1;

   while(k>=0){
       if(!tradeObj.PositionClose(PositionGetSymbol(k))){
          PrintFormat("Position Close Error = %d",GetLastError());
     //     return(false);   
       }else{
          k-- ;
       } 
      
      }   
   return(true);

}
//+------------------------------------------------------------------+
//| Caclulate the profit/loss in pip Function                        |
//+------------------------------------------------------------------+
double spaceCal(int level)
{
   int count;
   double test;
    if (MathMod(level,2) ==0){
      count = (level/2)*3+((level/2)-1)*2; 
   }
   else{ 
      count = (level/2)*3+(level/2)*2; 
     }
     
      PositionSelectByTicket(baseTickets[count]);
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY){
         levelDiff[count] = -PositionGetDouble(POSITION_PRICE_OPEN) + SymbolInfoDouble(PositionGetString(POSITION_SYMBOL),SYMBOL_BID);
         if(SymbolInfoInteger(PositionGetString(POSITION_SYMBOL),SYMBOL_DIGITS) == 3){
            levelDiff[count]= levelDiff[count]/100;
           
         }
          test = levelDiff[count];
     }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){
         levelDiff[count] = PositionGetDouble(POSITION_PRICE_OPEN) - SymbolInfoDouble(PositionGetString(POSITION_SYMBOL),SYMBOL_ASK);  
        if(SymbolInfoInteger(PositionGetString(POSITION_SYMBOL),SYMBOL_DIGITS) == 3){
           levelDiff[count]= levelDiff[count]/100;
          
            }
             test = levelDiff[count];
        }else {
            PrintFormat("spaceCal error");
            return(false);
      }
  
   
      return(levelDiff[count]);
}

//+------------------------------------------------------------------+
//| Check Speard of symbols                                            |
//+------------------------------------------------------------------+
bool checkSpread(int level){
   int i,spread,count,num;
    if (MathMod(level,2) ==0){
      num = 2;
      count = (level/2)*3+((level/2)-1)*2; 
   }
   else{ 
      num = 3;
      count = (level/2)*3+(level/2)*2; 
     }
     for(i=count;i<(count+num);i++){  
      spread = SymbolInfoInteger(symbolOrder[i],SYMBOL_SPREAD);
      if(spread >= pointTradeThereshold) return(false);  
   }
   return(true);
 
 
 }
