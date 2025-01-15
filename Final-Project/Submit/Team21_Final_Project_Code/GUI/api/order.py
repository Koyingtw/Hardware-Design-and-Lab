import os
from binance.client import Client
from binance.enums import *
import math

asset_list = ['BTC', 'ETH', 'BNB', 'SOL', 'BUSD']

def market_order(client, symbol, side, quantity, leverage=100):
    symbol = symbol.upper()
    if symbol not in asset_list:
        print(f"無效的交易對: {symbol}")
        return None
    symbol = symbol + 'USDT'
    print(f"執行市價{side}單: {quantity} {symbol.upper()} x{leverage}")
    print(client.futures_change_leverage(
        symbol=symbol,
        leverage=leverage
    ))
    try:
        order = client.futures_create_order(
            symbol=symbol.upper(),
            side=side,
            type='MARKET',
            quantity=quantity
        )
        print(order)
        return order
    except Exception as e:
        print(f"下單錯誤: {e}")
        return None
    
def limit_order(client, symbol, side, quantity, price):
    try:
        order = client.futures_create_order(
            symbol=symbol.upper(),
            side=side,
            type='LIMIT',
            quantity=quantity,
            price=price
        )
        return order
    except Exception as e:
        print(f"下單錯誤: {e}")
        return e

def change_leverage(client, symbol, leverage):
    symbol = symbol.upper()
    if symbol not in asset_list:
        print(f"無效的交易對: {symbol}")
        return None
    symbol = symbol + 'USDT'
    try:
        print(result = client.futures_change_leverage(
            symbol=symbol,
            leverage=leverage
        ))
        return result
    except Exception as e:
        print(f"更改槓桿錯誤: {e}")
        return e
    

def close_position(client, symbol):
    symbol = symbol.upper()
    if symbol not in asset_list:
        print(f"無效的交易對: {symbol}")
        return None
    symbol = symbol + 'USDT'
    try:
        # 獲取當前倉位信息
        positions = client.futures_position_information(symbol=symbol)
        
        for position in positions:
            # 檢查是否有持倉
            position_amt = float(position['positionAmt'])
            if position_amt != 0:
                # 決定平倉方向
                side = "SELL" if position_amt > 0 else "BUY"
                # 取絕對值作為平倉數量
                quantity = abs(position_amt)
                
                # 執行市價平倉
                order = client.futures_create_order(
                    symbol=symbol,
                    side=side,
                    type='MARKET',
                    quantity=quantity,
                    reduceOnly=True  # 確保只平倉不開新倉
                )
                return order
                
    except Exception as e:
        print(f"平倉錯誤: {e}")
        return None

def get_klines(client, symbol):
    symbol = symbol.upper()
    if symbol not in asset_list:
        print(f"無效的交易對: {symbol}")
        return None
    symbol = symbol + 'USDT'
    candles = client.futures_klines(
        symbol=symbol,
        interval=Client.KLINE_INTERVAL_1MINUTE,
    )
    data = []
    for i in range(-1, -6, -1):
        candles[i][0] = int(candles[i][0] / 1000 % 256)
        candles[i][1] = math.ceil(float(candles[i][1]))
        candles[i][2] = math.ceil(float(candles[i][2]))
        candles[i][3] = math.ceil(float(candles[i][3]))
        candles[i][4] = math.ceil(float(candles[i][4]))
        candles[i][5] = math.ceil(float(candles[i][5]))

        data.append(candles[i][:6])
    return data

    

# change value of candles[-2][:5] to int

# market_order(symbol='BTCUSDT', side='BUY', quantity=0.005)