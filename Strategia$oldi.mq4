//+------------------------------------------------------------------+
//|                                                     Ema5Ema8.mq4 |
//|                                                             drew |
//|                      https://www.tradingview.com/chart/T1FBm7MH/ |
//+------------------------------------------------------------------+
#property strict;

extern int magic;
int ticket;
extern double rischio=5;
extern double conto;
extern double slLong;
extern double slShort;
extern double currprice;

//+------------------------------------------------------------------+
//|   diamo al conto il valore attuale del capitale                  |
//+------------------------------------------------------------------+
void OnInit()
   {
    conto=AccountBalance();  
   }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|   funzione main                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if (AccountBalance()>conto)
     {
      conto=AccountBalance();
     } 
   if(nuovaBarra())
     {

      ordineLong();
      ordineShort();
     }
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|   funzione per capire se è stata creata una nuova barra          |
//+------------------------------------------------------------------+
bool nuovaBarra()
  {
   static datetime lastbar;
   datetime curbar = Time[0];
   if(lastbar!=curbar)
     {
      lastbar=curbar;
      return (true);
     }
   else
     {
      return(false);
     }
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  funzione per trovare lo sl dei segnali long                     |
//+------------------------------------------------------------------+
double calcoloslLong()
  {
   double sl;
   double lowPrecedenteSegnale = iLow(Symbol(),PERIOD_CURRENT,1);
   double lowPreprecedenteSegnale = iLow(Symbol(),PERIOD_CURRENT,2);
//if per capire lo sl
   if(lowPrecedenteSegnale>lowPreprecedenteSegnale)
     {
      sl=lowPreprecedenteSegnale;
      currprice=Close[2];
     }
   else
     {
      sl=lowPrecedenteSegnale;
      currprice=Close[1];
     }

   return sl;
  }
//+------------------------------------------------------------------+
//|       funzione per trovare lo sl dei segnali short               |
//+------------------------------------------------------------------+
double calcoloslShort()
  {
   double sl;
   double highPrecedenteSegnale = iHigh(Symbol(),PERIOD_CURRENT,1);
   double highPreprecedenteSegnale = iHigh(Symbol(),PERIOD_CURRENT,2);
//if per capire lo sl
   if(highPrecedenteSegnale>highPreprecedenteSegnale)
     {
      sl=highPrecedenteSegnale;
      currprice=Close[1];
     }
   else
     {
      sl=highPreprecedenteSegnale;
      currprice=Close[2];
     }

   return sl;



  }
  //+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  controllo creazione segnale e ordine long                       |
//+------------------------------------------------------------------+
void ordineLong()
  {
   double slLong=calcoloslLong();
   double lotti=calcololottilong();
   double ema5=iMA(Symbol(),PERIOD_CURRENT,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ema8=iMA(Symbol(),PERIOD_CURRENT,8,0,MODE_EMA,PRICE_CLOSE,0);
   double ema5_precedente=iMA(Symbol(),PERIOD_CURRENT,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ema8_precedente=iMA(Symbol(),PERIOD_CURRENT,8,0,MODE_EMA,PRICE_CLOSE,0);
   if((ema5>ema8)&&(ema5_precedente<ema8_precedente))
     {
      ticket = OrderSend(Symbol(),OP_BUY,lotti,Ask,0,slLong,0,NULL,0,0,0);
     }

  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| controllo creazione segnale e ordine short                       |
//+------------------------------------------------------------------+
void ordineShort()
  {
   double slShort=calcoloslShort();
   double lotti=calcololottishort();
   double ema5=iMA(Symbol(),PERIOD_CURRENT,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ema8=iMA(Symbol(),PERIOD_CURRENT,8,0,MODE_EMA,PRICE_CLOSE,0);
   double ema5_precedente=iMA(Symbol(),PERIOD_CURRENT,5,0,MODE_EMA,PRICE_CLOSE,0);
   double ema8_precedente=iMA(Symbol(),PERIOD_CURRENT,8,0,MODE_EMA,PRICE_CLOSE,0);
   if((ema5<ema8)&&(ema5_precedente>ema8_precedente))
     {
      ticket = OrderSend(Symbol(),OP_SELL,lotti,Bid,0,slShort,0,NULL,0,0,0);
     }

  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| calcolo lotti long                                               |
//+------------------------------------------------------------------+
double calcololottilong()
   {
    double soldirischiati=((conto*rischio)/100);
    double pipsquantity=(currprice-slLong);
    double numerolotti=(soldirischiati/(pipsquantity*10));
    return numerolotti;
   }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| calcolo lotti short                                              |
//+------------------------------------------------------------------+
double calcololottishort()
   {
    double soldirischiati=((conto*rischio)/100);
    double pipsquantity=(slShort-currprice);
    double numerolotti=(soldirischiati/(pipsquantity*10));
    return numerolotti;
   }
//+------------------------------------------------------------------+
