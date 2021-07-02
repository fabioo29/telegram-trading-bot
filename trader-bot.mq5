#property copyright "github.com/fabioo29 AutoTrader v2.00 - Foreign Exchange Helper BOT"
#property link "https://www.mql5.com"
#property version "1.00"

#include <Telegram.mqh>
#include <Trade\Trade.mqh>

input string Token = "BOT_TOKEN"; // BOT Token
input float RiskReward = 3.00;
string output_sring, interval;  
double lote = 0.01, ask_price, profit, entry_point, secure_trade = 100.00, profit_pips, stoploss_pips;
ulong ticket[5];
int direction, counter = 0;

CCustomBot bot;
CTrade trade;

int OnInit() {
  EventSetTimer(1);

  bot.Token(Token);
  if (bot.GetMe() != 0) {
    Alert("Bot startup error");
    return INIT_FAILED;
  }

  activate("on");
  bot.SendMessage(811397874, output_sring);
  return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
  activate("off");
  bot.SendMessage(811397874, output_sring);
}

void OnTick() {

      for(int i=PositionsTotal()-1; i>=0; i--)
      {
         ticket[i] = PositionGetTicket(i);
         direction = PositionGetInteger(POSITION_TYPE);
         
         if(direction == POSITION_TYPE_BUY)
         {
             ask_price = PositionGetDouble(POSITION_PRICE_CURRENT);
             entry_point = PositionGetDouble(POSITION_PRICE_OPEN);
             
             if(ask_price < 100)
             {  
               //if((PositionGetDouble(POSITION_SL) < entry_point)){ PrintFormat("%s %.5f - %.5f = %.5f // %.5f", PositionGetSymbol(i), ask_price, entry_point, (ask_price - entry_point), (1.00/10000.00));}          
               if(((ask_price - entry_point) >= (140.00/10000.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/10000.00 < entry_point+110.00/10000.00)){ trade.PositionModify(ticket[i], entry_point+110.00/10000.00-secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP5 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 110 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); } //TP5 (+140)
               else if(((ask_price - entry_point) >= (110.00/10000.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/10000.00 < entry_point+80.00/10000.00)){ trade.PositionModify(ticket[i], entry_point+80.00/10000.00-secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP4 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 80 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); } //TP4 (+110)
               else if(((ask_price - entry_point) >= (80.00/10000.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/10000.00 < entry_point+50.00/10000.00)){ trade.PositionModify(ticket[i], entry_point+50.00/10000.00-secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP3 HIT! \xF4B0\xF4B0\xF4B0\nSL MOVED TO 50 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); } // TP3 (+80)
               else if(((ask_price - entry_point) >= (50.00/10000.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/10000.00 < entry_point+20.00/10000.00)){ trade.PositionModify(ticket[i], entry_point+20.00/10000.00-secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP2 HIT! \xF4B0\xF4B0\nSL MOVED TO 20 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); } // TP2 (+50)
               else if(((ask_price - entry_point) >= (20.00/10000.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/10000.00 < entry_point)){ trade.PositionModify(ticket[i], entry_point-secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP1 HIT! \xF4B0\nSL MOVED TO EP! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }   // TP1 (+20)
               else if((ask_price <= (PositionGetDouble(POSITION_SL)+secure_trade/10000.00)) && (PositionGetDouble(POSITION_PROFIT) < 0.00)){ output_sring = StringFormat("\x274C B %s SL HIT!\nTRADE LOSS: %.0f PIPs", PositionGetSymbol(i), (PositionGetDouble(POSITION_PRICE_CURRENT)-entry_point)*(10000.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if((ask_price <= (PositionGetDouble(POSITION_SL)+secure_trade/10000.00)) && (PositionGetDouble(POSITION_PROFIT) >= 0.00)){ output_sring = StringFormat("\xF525 B %s CLOSED!\nTRADE PROFIT: %.0f PIPs", PositionGetSymbol(i), (PositionGetDouble(POSITION_PRICE_CURRENT)-entry_point)*(10000.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if(ask_price >= (PositionGetDouble(POSITION_TP)-secure_trade/10000.00)){ output_sring = StringFormat("\xF680 B %s HIT THE TOP!\nTRADE PROFIT: %.0f PIPs (%.2f$)", PositionGetSymbol(i), (ask_price-entry_point)*(10000.00), PositionGetDouble(POSITION_PROFIT)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // TP
             } else
             {
               //if((PositionGetDouble(POSITION_SL) < entry_point)){ PrintFormat("%s %.3f - %.3f = %.3f // %.3f", PositionGetSymbol(i), ask_price, entry_point, (ask_price - entry_point), (1.00/100.00));}     
               if(((ask_price - entry_point) >= (140.00/100.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/100.00 < entry_point+110.00/100.00)){ trade.PositionModify(ticket[i], entry_point+110.00/100.00-secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP5 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 110 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }  
               else if(((ask_price - entry_point) >= (110.00/100.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/100.00 < entry_point+80.00/100.00)){ trade.PositionModify(ticket[i], entry_point+80.00/100.00-secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP4 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 80 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((ask_price - entry_point) >= (80.00/100.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/100.00 < entry_point+50.00/100.00)){ trade.PositionModify(ticket[i], entry_point+50.00/100.00-secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP3 HIT! \xF4B0\xF4B0\xF4B0\nSL MOVED TO 50 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((ask_price - entry_point) >= (50.00/100.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/100.00 < entry_point+20.00/100.00)){ trade.PositionModify(ticket[i], entry_point+20.00/100.00-secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP2 HIT! \xF4B0\xF4B0\nSL MOVED TO 20 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((ask_price - entry_point) >= (20.00/100.00)) && (PositionGetDouble(POSITION_SL)+secure_trade/100.00 < entry_point)){ trade.PositionModify(ticket[i], entry_point-secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("B %s - TP1 HIT! \xF4B0\nSL MOVED TO EP! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if((ask_price <= (PositionGetDouble(POSITION_SL)+secure_trade/100.00)) && (PositionGetDouble(POSITION_PROFIT) < 0.00)){ output_sring = StringFormat("\x274C B %s SL HIT!\nTRADE LOSS: %.0f PIPs", PositionGetSymbol(i), (ask_price-entry_point)*(100.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if((ask_price <= (PositionGetDouble(POSITION_SL)+secure_trade/100.00)) && (PositionGetDouble(POSITION_PROFIT) >= 0.00)){ output_sring = StringFormat("\xF525 B %s CLOSED!\nTRADE PROFIT: %.0f PIPs", PositionGetSymbol(i), (ask_price-entry_point)*(100.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if(ask_price >= (PositionGetDouble(POSITION_TP)-secure_trade/100.00)){ output_sring = StringFormat("\xF680 B %s HIT THE TOP!\nTRADE PROFIT: %.0f PIPs (%.2f$)", PositionGetSymbol(i), (ask_price-entry_point)*(100.00), PositionGetDouble(POSITION_PROFIT)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // TP
             }
         } else if (direction == POSITION_TYPE_SELL)
         {
             ask_price = PositionGetDouble(POSITION_PRICE_CURRENT);
             entry_point = PositionGetDouble(POSITION_PRICE_OPEN);
             
             if(ask_price < 100)
             { 
               //if((PositionGetDouble(POSITION_SL) > entry_point)){ PrintFormat("%s %.5f - %.5f = %.5f // %.5f", PositionGetSymbol(i), entry_point, ask_price, (entry_point - ask_price), (1.00/10000.00));}    1.12345 = 112345
               if(((entry_point - ask_price) >= (140.00/10000.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/10000.00 > entry_point-110.00/10000.00)){ trade.PositionModify(ticket[i], entry_point-110.00/10000.00+secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP5 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 110 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (110.00/10000.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/10000.00 > entry_point-80.00/10000.00)){ trade.PositionModify(ticket[i], entry_point-80.00/10000.00+secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP4 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 80 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (80.00/10000.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/10000.00 > entry_point-50.00/10000.00)){ trade.PositionModify(ticket[i], entry_point-50.00/10000.00+secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP3 HIT! \xF4B0\xF4B0\xF4B0\nSL MOVED TO 50 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (50.00/10000.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/10000.00 > entry_point-20.00/10000.00)){ trade.PositionModify(ticket[i], entry_point-20.00/10000.00+secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP2 HIT! \xF4B0\xF4B0\nSL MOVED TO 20 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (20.00/10000.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/10000.00 > entry_point)){ trade.PositionModify(ticket[i], entry_point+secure_trade/10000.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP1 HIT! \xF4B0\nSL MOVED TO EP! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if((ask_price >= (PositionGetDouble(POSITION_SL)-secure_trade/10000.00)) && (PositionGetDouble(POSITION_PROFIT) < 0.00)){ output_sring = StringFormat("\x274C S %s SL HIT!\nTRADE LOSS: %.0f PIPs", PositionGetSymbol(i), (entry_point-ask_price)*(10000.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if((ask_price >= (PositionGetDouble(POSITION_SL)-secure_trade/10000.00)) && (PositionGetDouble(POSITION_PROFIT) >= 0.00)){ output_sring = StringFormat("\xF525 S %s CLOSED!\nTRADE PROFIT: %.0f PIPs", PositionGetSymbol(i), (entry_point-ask_price)*(10000.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if(ask_price <= (PositionGetDouble(POSITION_TP)+secure_trade/10000.00)){ output_sring = StringFormat("\xF680 S %s HIT THE TOP!\nTRADE PROFIT: %.0f PIPs (%.2f$)", PositionGetSymbol(i), (entry_point-ask_price)*(10000.00), PositionGetDouble(POSITION_PROFIT)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // TP
             } else
             {
               //if((PositionGetDouble(POSITION_SL) > entry_point)){ PrintFormat("%s %.3f - %.3f = %.3f // %.3f", PositionGetSymbol(i), entry_point, ask_price, (entry_point - ask_price), (1.00/100.00));}
               if(((entry_point - ask_price) >= (140.00/100.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/100.00 > entry_point-110.00/100.00)){ trade.PositionModify(ticket[i], entry_point-110.00/100.00+secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP5 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 110 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); } 
               else if(((entry_point - ask_price) >= (110.00/100.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/100.00 > entry_point-80.00/100.00)){ trade.PositionModify(ticket[i], entry_point-80.00/100.00+secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP4 HIT! \xF4B0\xF4B0\xF4B0\xF4B0\nSL MOVED TO 80 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (80.00/100.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/100.00 > entry_point-50.00/100.00)){ trade.PositionModify(ticket[i], entry_point-50.00/100.00+secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP3 HIT! \xF4B0\xF4B0\xF4B0\nSL MOVED TO 50 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (50.00/100.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/100.00 > entry_point-20.00/100.00)){ trade.PositionModify(ticket[i], entry_point-20.00/100.00+secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP2 HIT! \xF4B0\xF4B0\nSL MOVED TO 20 PIPs! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if(((entry_point - ask_price) >= (20.00/100.00)) && (PositionGetDouble(POSITION_SL)-secure_trade/100.00 > entry_point)){ trade.PositionModify(ticket[i], entry_point+secure_trade/100.00, PositionGetDouble(POSITION_TP)); output_sring = StringFormat("S %s - TP1 HIT! \xF4B0\nSL MOVED TO EP! ", PositionGetSymbol(i)); bot.SendMessage(811397874, output_sring); }
               else if((ask_price >= (PositionGetDouble(POSITION_SL)-secure_trade/100.00)) && (PositionGetDouble(POSITION_PROFIT) < 0.00)){ output_sring = StringFormat("\x274C S %s SL HIT!\nTRADE LOSS: %.0f PIPs", PositionGetSymbol(i), (entry_point-ask_price)*(100.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if((ask_price >= (PositionGetDouble(POSITION_SL)-secure_trade/100.00)) && (PositionGetDouble(POSITION_PROFIT) >= 0.00)){ output_sring = StringFormat("\xF525 S %s CLOSED!\nTRADE PROFIT: %.0f PIPs", PositionGetSymbol(i), (entry_point-ask_price)*(100.00)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // SL
               else if(ask_price <= (PositionGetDouble(POSITION_TP)+secure_trade/100.00)){ output_sring = StringFormat("\xF680 S %s HIT THE TOP!\nTRADE PROFIT: %.0f PIPs (%.2f$)", PositionGetSymbol(i), (entry_point-ask_price)*(100.00), PositionGetDouble(POSITION_PROFIT)); trade.PositionClose(ticket[i], 0.0); bot.SendMessage(811397874, output_sring);} // TP
             } 
         }
      }
      positions_list(); 
}

void positions_list()
{
   if(PositionsTotal() != 0)
   {
      profit = 0;
      profit_pips = 0;
      output_sring = "";
      for(int i=PositionsTotal()-1; i>=0; i--)
      {
         ticket[i] = PositionGetTicket(i); // Get all order tickets
         if((PositionGetSymbol(i) == "AUDJPY") || (PositionGetSymbol(i) == "EURJPY") || (PositionGetSymbol(i) == "GBPJPY") || (PositionGetSymbol(i) == "USDJPY"))
         { 
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*100.00);
               output_sring += StringFormat("[ %1d ]  B %-7s    |  %9.2f$   |    %6.1f\n", i, PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*100.00), ticket[i]);
            }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
               profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*100.00);
               output_sring += StringFormat("[ %1d ]  S %-7s    |  %9.2f$   |    %6.1f\n", i, PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*100.00), ticket[i]);
            }
         }
         else
         { 
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00);
               output_sring += StringFormat("[ %1d ]  B %-8s  |  %9.2f$   |    %6.1f\n", i, PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00), ticket[i]);
            }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
               profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*10000.00);
               output_sring += StringFormat("[ %1d ]  S %-8s  |  %9.2f$   |    %6.1f\n", i, PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*10000.00), ticket[i]);
            }               
         }
         profit += (PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP));
      }
      output_sring += StringFormat("\n[ ALL ]  PROFIT     |  %9.2f$   |    %6.1f", profit, profit_pips);
   } else
   {
      output_sring = "No open positions!";
   }
}

void activate(string to_print)
{     
      if(PositionsTotal() == 0)
      {
         if ((to_print == "on") || (to_print == "ON"))
         {
            output_sring = "\x26A0 Starting EA!\nNo open positions.";
         }
         else if ((to_print == "off") || (to_print == "OFF"))
         {
            output_sring = "\x26A0 Shutting down EA!\nNo open positions.";
            bot.SendMessage(811397874, output_sring); 
            TerminalClose(0);
         }
         else
         {
           output_sring = "No open positions. You can leave or open positions!"; 
         }
      }
      else if ((to_print == "on") || (to_print == "ON"))
       {
         for(int i=PositionsTotal()-1; i>=0; i--)
         {
            ticket[i] = PositionGetTicket(i);
            direction = PositionGetInteger(POSITION_TYPE);
            
            if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100.00) stoploss_pips = (MathAbs(PositionGetDouble(POSITION_SL)-PositionGetDouble(POSITION_PRICE_OPEN)))*10000.00;
            else stoploss_pips = (MathAbs(PositionGetDouble(POSITION_SL)-PositionGetDouble(POSITION_PRICE_OPEN)))*100.00;
            
            if(stoploss_pips > secure_trade)
           {
              output_sring = "\x26A0 Starting EA!\nYour postions have been readjusted...";
              return;
           }
           else if(direction == POSITION_TYPE_BUY)
            {          
                if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100)
                { 
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)-secure_trade/10000.00)*100000.00)/100000.00, MathFloor((PositionGetDouble(POSITION_TP)+secure_trade/10000.00)*100000.00)/100000.00); 
                } else
                {
                 trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)-secure_trade/100.00)*1000.00)/1000.00, MathFloor((PositionGetDouble(POSITION_TP)+secure_trade/100.00)*1000.00)/1000.00);
                }
            } else if (direction == POSITION_TYPE_SELL)
            {          
                if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100)
                { 
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)+secure_trade/10000.00)*100000.00)/100000.00, MathFloor((PositionGetDouble(POSITION_TP)-secure_trade/10000.00)*100000.00)/100000.00);
                } else
                { 
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)+secure_trade/100.00)*1000.00)/1000.00, MathFloor((PositionGetDouble(POSITION_TP)-secure_trade/100.00)*1000.00)/1000.00);
                } 
            }
         }
         output_sring = "\x26A0 Starting EA!\nYour postions have been readjusted...";
       }
       else if ((to_print == "off") || (to_print == "OFF"))
       {
         for(int i=PositionsTotal()-1; i>=0; i--)
         {
            ticket[i] = PositionGetTicket(i);
            direction = PositionGetInteger(POSITION_TYPE);
            
            if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100.00) stoploss_pips = (MathAbs(PositionGetDouble(POSITION_SL)-PositionGetDouble(POSITION_PRICE_OPEN)))*10000.00;
            else stoploss_pips = (MathAbs(PositionGetDouble(POSITION_SL)-PositionGetDouble(POSITION_PRICE_OPEN)))*100.00;
            
            if(stoploss_pips < secure_trade)
            {
              output_sring = "\x26A0 Shutting down EA!\nYour postions have been readjusted...";
              bot.SendMessage(811397874, output_sring); 
              TerminalClose(0);
            }
            else if(direction == POSITION_TYPE_BUY)
            {          
                if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100)
                { 
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)+secure_trade/10000.00)*100000.00)/100000.00, MathFloor((PositionGetDouble(POSITION_TP)-secure_trade/10000.00)*100000.00)/100000.00);
                } else
                { 
                 trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)+secure_trade/100.00)*1000.00)/1000.00, MathFloor((PositionGetDouble(POSITION_TP)-secure_trade/100.00)*1000.00)/1000.00);
                }
            } else if (direction == POSITION_TYPE_SELL)
            {          
                if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100)
                { 
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)-secure_trade/10000.00)*100000.00)/100000.00, MathFloor((PositionGetDouble(POSITION_TP)+secure_trade/10000.00)*100000.00)/100000.00);
                } else
                {
                  trade.PositionModify(ticket[i], MathFloor((PositionGetDouble(POSITION_SL)-secure_trade/100.00)*1000.00)/1000.00, MathFloor((PositionGetDouble(POSITION_TP)+secure_trade/100.00)*1000.00)/1000.00);
                } 
            }
         }
         output_sring = "\x26A0 Shutting down EA!\nYour postions have been readjusted...";
         bot.SendMessage(811397874, output_sring); 
         TerminalClose(0);
       }
       else
       {
          output_sring = "\x26A0 Unknown command.Try /turn [ON/OFF]"; 
       }
}

void OnTimer() {  
  //---  
  if(counter == (60*28)){ positions_list(); bot.SendMessage(811397874, output_sring); counter = 0;}
  else counter++;
  
  bot.GetUpdates(); // get messages

  // Process and send messages
  for (int i = 0; i < bot.ChatsTotal(); i++) 
  {
    CCustomChat * chat = bot.m_chats.GetNodeAtIndex(i);
    //--- if message was not processes
    if (!chat.m_new_one.done) 
    {
      chat.m_new_one.done = true;
      string to_split = chat.m_new_one.message_text; // text received by user
      string sep = " "; // string separator
      ushort u_sep;
      string result[5] = {"NULL", "NULL", "NULL", "NULL", "NULL"}; // processed received message (strings type array)

      u_sep = StringGetCharacter(sep, 0);
      int k = StringSplit(to_split, u_sep, result);
      
      if (result[0] == "/help") // show all avaliable BOT commands
      {
         output_sring = "";
         output_sring += "0.  /buy (PAR) (stoploss_pips) - Buy order\n\n";
		 output_sring += "1.  /buy (PAR) (stoploss_pips) (RATE) (DURATION) - Buy limit order\n\n";
         output_sring += "2.  /sell (PAR) (SL PIPS) - Sell order\n\n";
		 output_sring += "3.  /sell (PAR) (SL PIPS) (RATE) (DURATION) - Sell limit order\n\n";
         output_sring += "4.  /list - List all open trades\n\n";
         output_sring += "5.  /close (nº de id em /list)/(ALL) - Close position(s)\n\n";
         output_sring += "6.  /alert (PAR) (PRICE) (DURAÇAO(MINS)) - Schedule price alert(pair)\n\n";
         output_sring += "7.  /lote (LOTE SIZE) - change lote size\n\n";
         output_sring += "8.  /price (PAR) - Verify pair price and current spread\n\n";
         output_sring += "9.  /version - Version and credits\n\n";
         output_sring += "10. /profit (D/S/M/A/ALL) - Current profit\n\n";
         output_sring += "11. /turn (ON/OFF) - Turn (on/off) supervised trades \n\n";
         output_sring += "12. /sl (nº de id em /list) (SL_RATE) - change stop loss";
         bot.SendMessage(chat.m_id, output_sring);
      }
      
      if (result[0] == "/buy")   // Buy order
      {
         if((result[1] != "NULL") && (result[2] != "NULL"))
         {
            if(PositionsTotal() < 5 )
            {
               if((result[3] == "NULL") && (result[4] == "NULL")) // buy order with current price
               {
                  ask_price = NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_ASK),_Digits); // current ask price
                  output_sring = "";
                  if (ask_price < 100){ // 1.12345
                     trade.Buy(lote, result[1], 0.0, ask_price-(StringToDouble(result[2]))/10000.00-secure_trade/10000.00, ask_price+(StringToDouble(result[2])*RiskReward)/10000.00+secure_trade/10000.00,""); // make a buy order(lote, pair, price, SL, TP)
                     output_sring += StringFormat("BUY %s %.4f\n", result[1], MathFloor(ask_price*10000.00)/10000.00);
                     output_sring += StringFormat("TP %.4f [%.0f PIPS]\n", MathFloor((ask_price+(StringToDouble(result[2])*RiskReward)/10000.00)*10000.00)/10000.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.4f [%.0f PIPS]", MathFloor((ask_price-(StringToDouble(result[2]))/10000.00)*10000.00)/10000.00, StringToDouble(result[2]));
                  } else // 111.123
                  { 
                     trade.Buy(lote, result[1], 0.0, ask_price-(StringToDouble(result[2]))/100.00-secure_trade/100.00, ask_price+(StringToDouble(result[2])*RiskReward)/100.00+secure_trade/100.00,""); // make a buy order(lote, pair, price, SL, TP)
                     output_sring += StringFormat("BUY %s %.2f\n", result[1], MathFloor(ask_price*100.00)/100.00);
                     output_sring += StringFormat("TP %.2f [%.0f PIPS]\n", MathFloor((ask_price+(StringToDouble(result[2])*RiskReward)/100.00)*100.00)/100.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.2f [%.0f PIPS]\n", MathFloor((ask_price-(StringToDouble(result[2]))/100.00)*100.00)/100.00, StringToDouble(result[2]));
                  }
                  bot.SendMessage(chat.m_id, output_sring);
                  positions_list();
                  bot.SendMessage(chat.m_id, output_sring);
               }
               else // Buy Limit ORDER -> /buy EURUSD 20 1.1231 60
               {
                  ask_price = NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_ASK),_Digits); // current ask price
                  output_sring = "";
                  if (ask_price < 100){ // 1.12345
                     trade.BuyLimit(lote, StringToDouble(result[3]), result[1], StringToDouble(result[3])-(StringToDouble(result[2]))/10000.00-secure_trade/10000.00, StringToDouble(result[3])+(StringToDouble(result[2])*RiskReward)/10000.00+secure_trade/10000.00, ORDER_TIME_GTC, TimeCurrent()+StringToInteger(result[4])*60); // make a buy limit order(lote, price, pair, sl, tp, ORDER_TIME_GTC, TimeCurrent()+StringToInteger(result[4]))
                     output_sring += StringFormat("BUY LIMIT %s %.4f [%s mins]\n", result[1], MathFloor(StringToDouble(result[3])*10000.00)/10000.00, result[4]);
                     output_sring += StringFormat("TP %.4f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])+(StringToDouble(result[2])*RiskReward)/10000.00)*10000.00)/10000.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.4f [%.0f PIPS]", MathFloor((StringToDouble(result[3])-(StringToDouble(result[2]))/10000.00)*10000.00)/10000.00, StringToDouble(result[2]));
                  } else // 111.123
                  { 
                     trade.BuyLimit(lote, StringToDouble(result[3]), result[1], StringToDouble(result[3])-(StringToDouble(result[2]))/100.00-secure_trade/100.00, StringToDouble(result[3])+(StringToDouble(result[2])*RiskReward)/100.00+secure_trade/100.00, ORDER_TIME_GTC, TimeCurrent()+StringToInteger(result[4])*60);
                     output_sring += StringFormat("BUY LIMIT %s %.2f [%s mins]\n", result[1], MathFloor(StringToDouble(result[3])*100.00)/100.00, result[4]);
                     output_sring += StringFormat("TP %.2f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])+(StringToDouble(result[2])*RiskReward)/100.00)*100.00)/100.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.2f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])-(StringToDouble(result[2]))/100.00)*100.00)/100.00, StringToDouble(result[2]));
                  }
                  bot.SendMessage(chat.m_id, output_sring);
                  positions_list();
                  bot.SendMessage(chat.m_id, output_sring);
               }
            }else
            {
               bot.SendMessage(chat.m_id, "WARNING: trades open limit exceded(5)!");
               positions_list();
               bot.SendMessage(chat.m_id, output_sring);
            }
         }else
         {
               bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /buy [PAIR] [STOP LOSS PIPS]"); 
         }
      }  
      
      if (result[0] == "/sell")   // Sell order
      {
         if((result[1] != "NULL") && (result[2] != "NULL"))
         {
            if(PositionsTotal() < 5 )
            {
               if((result[3] == "NULL") && (result[4] == "NULL")) // Sell ORDER
               {
                  ask_price = NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_ASK),_Digits); // current ask price
                  output_sring = "";
                  if (ask_price < 100){ // 1.12345
                     trade.Sell(lote, result[1], 0.0, ask_price+(StringToDouble(result[2]))/10000.00+secure_trade/10000.00, ask_price-(StringToDouble(result[2])*RiskReward)/10000.00-secure_trade/10000.00,""); // make a sell order (lote, pair, price, SL, TP)
                     output_sring += StringFormat("SELL %s %.4f\n", result[1], MathFloor(ask_price*10000.00)/10000.00, result[4]);
                     output_sring += StringFormat("TP %.4f [%.0f PIPS]\n", MathFloor((ask_price-(StringToDouble(result[2])*RiskReward)/10000.00)*10000.00)/10000.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.4f [%.0f PIPS]", MathFloor((ask_price+(StringToDouble(result[2]))/10000.00)*10000.00)/10000.00, StringToDouble(result[2]));
                  } else // 111.123
                  {  
                     trade.Sell(lote, result[1], 0.0, ask_price+(StringToDouble(result[2]))/100.00+secure_trade/100.00, ask_price-(StringToDouble(result[2])*RiskReward)/100.00-secure_trade/100.00,""); // sell order
                     output_sring += StringFormat("SELL %s %.2f\n", result[1], MathFloor(ask_price*100.00)/100.00, result[4]);
                     output_sring += StringFormat("TP %.2f [%.0f PIPS]\n", MathFloor((ask_price-(StringToDouble(result[2])*RiskReward)/100.00)*100.00)/100.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.2f [%.0f PIPS]\n", MathFloor((ask_price+(StringToDouble(result[2]))/100.00)*100.00)/100.00, StringToDouble(result[2]));
                  }
                  bot.SendMessage(chat.m_id, output_sring);
                  positions_list();
                  bot.SendMessage(chat.m_id, output_sring);
               }
               else  // Sell Limit Order -> /sell EURUSD 20 1.1231 60
               {
                  ask_price = NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_ASK),_Digits); // current ask price
                  output_sring = "";
                  if (ask_price < 100){ // 1.12345
                     trade.SellLimit(lote, StringToDouble(result[3]), result[1], StringToDouble(result[3])+(StringToDouble(result[2]))/10000.00+secure_trade/10000.00, StringToDouble(result[3])-(StringToDouble(result[2])*RiskReward)/10000.00-secure_trade/10000.00, ORDER_TIME_GTC, TimeCurrent()+StringToInteger(result[4])*60);
                     output_sring += StringFormat("SELL LIMIT %s %.4f [%s misn]\n", result[1], MathFloor((StringToDouble(result[3])*10000.00))/10000.00);
                     output_sring += StringFormat("TP %.4f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])-(StringToDouble(result[2])*RiskReward)/10000.00)*10000.00)/10000.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.4f [%.0f PIPS]", MathFloor((StringToDouble(result[3])+(StringToDouble(result[2]))/10000.00)*10000.00)/10000.00, StringToDouble(result[2]));
                  } else // 111.123
                  { 
                     trade.SellLimit(lote, StringToDouble(result[3]), result[1], StringToDouble(result[3])+(StringToDouble(result[2]))/100.00+secure_trade/100.00, StringToDouble(result[3])-(StringToDouble(result[2])*RiskReward)/100.00-secure_trade/100.00, ORDER_TIME_GTC, TimeCurrent()+StringToInteger(result[4])*60);
                     output_sring += StringFormat("SELL LIMIT %s %.2f [%s mins]\n", result[1], MathFloor((StringToDouble(result[3])*100.00))/100.00);
                     output_sring += StringFormat("TP %.2f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])-(StringToDouble(result[2])*RiskReward)/100.00)*100.00)/100.00, StringToDouble(result[2])*RiskReward);
                     output_sring += StringFormat("SL %.2f [%.0f PIPS]\n", MathFloor((StringToDouble(result[3])+(StringToDouble(result[2]))/100.00)*100.00)/100.00, StringToDouble(result[2]));
                  }
                  bot.SendMessage(chat.m_id, output_sring);
                  positions_list();
                  bot.SendMessage(chat.m_id, output_sring);
               }
            }else
            {
               bot.SendMessage(chat.m_id, "WARNING: trades open limit exceded(5)!");
               positions_list();
               bot.SendMessage(chat.m_id, output_sring);
            }
         }else
         {
               bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /sell [PAIR] [STOP LOSS PIPS]"); 
         }
      }
      
       if (result[0] == "/list")   // list all open trades
      {
         positions_list();
         bot.SendMessage(chat.m_id, output_sring);
      }
      
       if (result[0] == "/close")   // close position(s)
      {
         if(result[1] != "NULL")
         {
            output_sring = "";
            profit = 0;
            profit_pips = 0;
            if ((result[1] == "ALL") || (result[1] == "all")){
               for(int i=PositionsTotal()-1; i>=0; i--)
               {
                  ticket[i] = PositionGetTicket(i);
                  trade.PositionClose(ticket[i]);
                  profit += PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP);
                  if (PositionGetDouble(POSITION_PRICE_CURRENT) < 100.00)
                  { 
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) 
                        profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00);
                     else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) 
                        profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*10000.00);
                  }else
                  { 
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) 
                        profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*100.00);
                     else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) 
                        profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*100.00);
                  }
               }
               output_sring = StringFormat("All positions closed [ %.2f$ ] [ %.0f PIPs ]", profit, profit_pips);
            } else
            {
               for(int i=PositionsTotal()-1; i>=0; i--)
               {
                  if (i == StringToInteger(result[1]))
                  {
                     ticket[i] = PositionGetTicket(i);
                     
                     if (PositionGetDouble(POSITION_PRICE_CURRENT) < 100.00)
                     { 
                        if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) 
                           profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00);
                        else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) 
                           profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*10000.00);
                     }else
                     { 
                        if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) 
                           profit_pips += ((PositionGetDouble(POSITION_PRICE_CURRENT)-PositionGetDouble(POSITION_PRICE_OPEN))*100.00);
                        else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) 
                           profit_pips += ((PositionGetDouble(POSITION_PRICE_OPEN)-PositionGetDouble(POSITION_PRICE_CURRENT))*100.00);
                     }
                     if (PositionGetDouble(POSITION_PRICE_CURRENT) < 100.00) output_sring = StringFormat("%s FECHADO [ %.2f$ ] [ %.0f PIPs ]", PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), profit_pips);
                     else output_sring = StringFormat("%s closed [ %.2f$ ] [ %.0f PIPs ]", PositionGetSymbol(i), PositionGetDouble(POSITION_PROFIT)-PositionGetDouble(POSITION_SWAP), profit_pips);
                     trade.PositionClose(ticket[i]);
                  }
               }        
            }
            
            bot.SendMessage(chat.m_id, output_sring);
            positions_list();
            bot.SendMessage(chat.m_id, output_sring);
         }else
         {
               bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /close [ALL] or [position id from /list]"); 
         }
      }
      
      if (result[0] == "/lote")   // change lote size for new positions
      {
         if(result[1] != "NULL")
         {
            output_sring = StringFormat("Lote size changed from %.2f to ", lote);
            lote = StringToDouble(result[1]);
            output_sring += StringFormat("%.2f", lote);
            bot.SendMessage(chat.m_id, output_sring);
         }else
         {
               bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /lote [NEW LOTE SIZE]"); 
         }
      }
      
      if (result[0] == "/price")   // price info for asked pair and current sprad
      {  
         output_sring = "";
         if(result[1] != "NULL")
         {  
            ask_price = NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_ASK),_Digits); // ask price
            if (ask_price < 100) output_sring = StringFormat("%s PRICE: %.5f\nSPREAD FEE: %.1f PIPs", result[1], MathFloor(ask_price*100000.00)/100000.00, (ask_price*100000.00-(NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_BID),_Digits))*100000.00)/10.00);
            else output_sring = StringFormat("%s PRICE:1 %.3f\nSPREAD FEE: %.1f PIPs", result[1], MathFloor(ask_price*1000.00)/1000.00, (ask_price*1000.00-(NormalizeDouble(SymbolInfoDouble(result[1], SYMBOL_BID),_Digits))*1000.00)/10.00);
            bot.SendMessage(chat.m_id, output_sring);
         }else
         {
               bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /price [PAIR]"); 
         }
      }
      
      if (result[0] == "/version")   // software version and credits
      {  
         bot.SendMessage(chat.m_id, "github.com/fabioo29 AutoTrader v2.00 - Foreign Exchange Helper BOT");
      }
      
      if (result[0] == "/profit")   // check current (day/week/month/year/all-time) profit
      {  
         if(result[1] != "NULL")
         {
            if((result[1] == "D") || (result[1] == "d")){ HistorySelect(TimeCurrent()-(24 * 60 * 60),TimeCurrent()); interval = "DAY";}
            if((result[1] == "W") || (result[1] == "w")){ HistorySelect(iTime(NULL,PERIOD_W1,0),TimeCurrent()); interval = "WEEK";}
            if((result[1] == "M") || (result[1] == "m")){ HistorySelect(iTime(NULL,PERIOD_MN1,0),TimeCurrent()); interval = "MONTH";}
            if((result[1] == "Y") || (result[1] == "y")){ HistorySelect(iTime(NULL,PERIOD_MN1,12),TimeCurrent()); interval = "YEAR";}
            if((result[1] == "ALL") || (result[1] == "all")){ HistorySelect(0,TimeCurrent()); interval = "ALL TIME";}
            
            profit = 0;
            for(int i=0; i<HistoryDealsTotal(); i++)
            {
               if((HistoryDealGetInteger(HistoryDealGetTicket(i),DEAL_TYPE) == DEAL_TYPE_BUY) || (HistoryDealGetInteger(HistoryDealGetTicket(i),DEAL_TYPE) == DEAL_TYPE_SELL)) 
                  profit += (HistoryDealGetDouble(HistoryDealGetTicket(i),DEAL_PROFIT)-HistoryDealGetDouble(HistoryDealGetTicket(i), DEAL_SWAP));
            }  
            output_sring = StringFormat("%s PROFIT =  %.2f$", interval, profit);
            bot.SendMessage(chat.m_id, output_sring);
         } else 
         {
            bot.SendMessage(chat.m_id, "\x26A0 Unknown command.Try /profit [D/W/M/Y/ALL]"); 
         }
      }
      
      if (result[0] == "/turn")   // Turn (on/off) supervised trades
      {
       string to_print = result[1];
       activate(to_print);
       bot.SendMessage(811397874, output_sring);
      }
      
      if (result[0] == "/sl")   // change current stop loss
      {
         if((result[1] != "NULL") && (result[2] != "NULL"))
         {
            for(int i=PositionsTotal()-1; i>=0; i--)
            {
               if (i == StringToInteger(result[1]))
               {
                  ticket[i] = PositionGetTicket(i);
                  
                  if(PositionGetDouble(POSITION_PRICE_CURRENT) < 100) // 1.1234
                  { 
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                     {
                        if(StringToDouble(result[2]) >= PositionGetDouble(POSITION_PRICE_OPEN))
                        {
                           output_sring = "The selected SL will close the position.\nTry /sl [ID] [SL_RATE]";
                        } else
                        {
                           output_sring = StringFormat("%s STOP LOSS CHANGED!\n%.4f(%.0f PIPs) -> %.4f(%.0f PIPs)", PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_SL)+secure_trade/10000.00, (PositionGetDouble(POSITION_PRICE_OPEN)-(PositionGetDouble(POSITION_SL)+secure_trade/10000.00))*10000.00, StringToDouble(result[2]), (PositionGetDouble(POSITION_PRICE_OPEN)-StringToDouble(result[2]))*10000.00);
                           trade.PositionModify(ticket[i], StringToDouble(result[2])-secure_trade/10000.00, PositionGetDouble(POSITION_TP));
                        }
                     }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                     {
                        if(StringToDouble(result[2]) <= PositionGetDouble(POSITION_PRICE_OPEN))
                        {
                           output_sring = "The selected SL will close the position.\nTry /sl [ID] [SL_RATE]";
                        } else
                        {
                           output_sring = StringFormat("%s STOP LOSS CHANGED!\n%.4f(%.0f PIPs) -> %.4f(%.0f PIPs)", PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_SL)-secure_trade/10000.00, ((PositionGetDouble(POSITION_SL)-secure_trade/10000.00)-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00, StringToDouble(result[2]), (StringToDouble(result[2])-PositionGetDouble(POSITION_PRICE_OPEN))*10000.00);
                           trade.PositionModify(ticket[i], StringToDouble(result[2])+secure_trade/10000.00, PositionGetDouble(POSITION_TP));
                        }
                     }
                  }
                  else // 101.12
                  { 
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                     {
                        if(StringToDouble(result[2]) >= PositionGetDouble(POSITION_PRICE_OPEN))
                        {
                           output_sring = "The selected SL will close the position.\nTry /sl [ID] [SL_RATE]";
                        } else
                        {
                           output_sring = StringFormat("%s STOP LOSS CHANGED!\n%.2f(%.0f PIPs) -> %.2f(%.0f PIPs)", PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_SL)+secure_trade/100.00, (PositionGetDouble(POSITION_PRICE_OPEN)-(PositionGetDouble(POSITION_SL)+secure_trade/100.00))*100.00, StringToDouble(result[2]), (PositionGetDouble(POSITION_PRICE_OPEN)-StringToDouble(result[2]))*100.00);
                           trade.PositionModify(ticket[i], StringToDouble(result[2])-secure_trade/100.00, PositionGetDouble(POSITION_TP));
                        }
                     }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                     {
                        if(StringToDouble(result[2]) <= PositionGetDouble(POSITION_PRICE_OPEN))
                        {
                           output_sring = "The selected SL will close the position.\nTry /sl [ID] [SL_RATE]";
                        } else
                        {
                           output_sring = StringFormat("%s STOP LOSS CHANGED!\n%.2f(%.0f PIPs) -> %.2f(%.0f PIPs)", PositionGetString(POSITION_SYMBOL), PositionGetDouble(POSITION_SL)-secure_trade/100.00, ((PositionGetDouble(POSITION_SL)-secure_trade/100.00)-PositionGetDouble(POSITION_PRICE_OPEN))*100.00, StringToDouble(result[2]), (StringToDouble(result[2])-PositionGetDouble(POSITION_PRICE_OPEN))*100.00);
                           trade.PositionModify(ticket[i], StringToDouble(result[2])+secure_trade/100.00, PositionGetDouble(POSITION_TP));
                        }
                     }               
                  }
               }
            }
            bot.SendMessage(chat.m_id, output_sring);  
            positions_list();                         
         } else 
         {
            bot.SendMessage(chat.m_id, "\x26A0 Unknown commando.Try /sl [ID] [SL_RATE]"); 
         }
      }
    }
  }
}

