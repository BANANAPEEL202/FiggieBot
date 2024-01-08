# FiggieBot
A statistics display for the Jane Street trading game, Figgie. A Python script/server records the screen and uses Pytesseract OCR to retrieve data from a Figgie.com game and send it to the Frontend UI which is based on Processing.org.  
This repo is configured to work specifically with an M2 Macbook Air 13" display with Figgie.com opened in Chrome at 90% Zoom and an external display. Configurations can be set up for different devices (see Configuration for more details)

# Description
The first row of bar charts shows how many of each suit each player has bought (in green) and sold (in red). The middle number is the net gain/loss of cards in each suit.
The second row of bar charts shows how many bids/offers each player has put on each suit. The numbers correspond to the average bid/offer price and not the actual number of bids/offers placed. 
The Card Counter adds up all of the negative deltas in a suit for each player. For example, if a player buys 1 Club and then sells 2 Clubs, we know that they had at least 1 Club in their starting hand. 
A red border around the display indicates that the screen is out of sync and therefore the OCR recognition will not work. 

# Installation
1. Download this repo
2. Install all dependencies for the Python Server (found in requirements.txt)
3. Download the Processing UI Executable from [here](https://www.dropbox.com/scl/fo/gc0esniabuzvkd9xy60qu/h?rlkey=nwmxmtbk1mx4xlibhjqa7lz08&dl=0)

# Usage
1. Run Server.py
2. Run the Processing.org executable
3. Join or host a game of Figgie.com
4. Once all players have joined, but before the game begins, click on the "Load Players" button. If any player names are incorrect, click on it to edit it.
5. Once the game begins, click "Count Cards". This will include the cards in your starting hand in the Card Counter.
6. If the player colors on Figgie.com do not match the player colors on the display, click "Swap Colors"
7. For a new round, click "New Round". 

# Configuration
1. Open up the Server.py in an IDE
2. Modify the frames (such as redFrame, tradeFrame) to crop the corresponding section of the screen on your device
3. For more help, feel free to open an issue

