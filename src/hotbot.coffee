# Description:
#   Allows a group of users to randomly decide who makes tea and coffee.
#
# Dependencies:
#   "hubot-slack": "2.0.3"
#
# Configuration:
#   HEROKU_URL
#   HUBOT_SLACK_TOKEN
#   HUBOT_SLACK_TEAM
#   HUBOT_SLACK_BOTNAME
#
# Commands:
#   i want <tea/coffee> - Adds an order to the pile.
#   <tea/coffee> please - Same.
#   how many rounds? - Informs the chat how many rounds and how many teas and coffees have been made.
#
# Notes:
#   Once five orders have been entered, Hotbot decides who shall make the drinks.
#   Emoji is supported - try :tea: and :coffee:!
#   Deploy the bot to Heroku.
#
# Author:
#   calumgunn

maxVotes = 5
participants = []
orders = []
resetTimer = null
previousWinner = null
winner = null

pickAWinner = (prev) ->
  winner = participants[Math.floor(Math.random() * participants.length)]
  pickAWinner prev if prev == winner

fiveDrinks = (robot, msg, drink) ->
  totalRounds = robot.brain.get 'totalRounds'
  if totalRounds == null
    totalRounds = 0
  robot.brain.set totalRounds: (totalRounds + 1)
  previousWinner = winner if winner?
  pickAWinner previousWinner
  orders.push("@#{msg.message.user.name}: #{drink}\n")
  formatted_orders = ("\n" + order for order in orders)
  msg.send "Final vote for #{drink} from @#{msg.message.user.name} - that makes #{participants.length}...
            \nHOT DRINKS TIME! The winner is: @#{winner.toUpperCase()}!
            \nORDERS:\n" + formatted_orders
  clearTimeout(resetTimer)
  participants = []
  orders = []
  return

processOrder = (robot, msg, drink) ->
  totalTeas = robot.brain.get 'teaCount'
  totalCoffees = robot.brain.get 'coffeeCount'
  msg.send "HIYA"
  if drink == 'tea' or drink == 'TEA' or drink == 'Tea'
    robot.brain.set 'teaCount', totalTeas + 1
  else
    robot.brain.set 'coffeeCount', totalCoffees + 1
  participants.push(msg.message.user.name)
  if participants.length is maxVotes
    fiveDrinks msg, drink
  else
    clearTimeout(resetTimer)
    resetTimer = setTimeout () ->
      msg.send "OH DARN! Not enough votes. RESETTING..."
      participants = []
      orders = []
    , 600000
    orders.push("@#{msg.message.user.name}: #{drink}")
    msg.send "One vote for #{drink} from @#{msg.message.user.name} - that makes #{participants.length}..."

module.exports = (robot) ->
  robot.hear /i want :?(tea|coffee):?/i, (msg) ->
    processOrder robot, msg, msg.match[1]

  robot.hear /:?(tea|coffee):? please/i, (msg) ->
    processOrder robot, msg, msg.match[1]

  robot.hear /i want :?pizza:?/i, (msg) ->
    responses = ["Well, who wouldn't?", "Me too.", "If only there were a Pizzabot...", "PIZZA? :pizza:?", "PIZZA. PIZZA. PIZZA. PIZZA. PIZZA. PIZZA. PIZZA."]
    msg.send msg.random responses

  robot.hear /how many rounds?/i, (msg) ->
    rounds = robot.brain.get('totalRounds')
    teas = robot.brain.get('teaCount')
    coffees = robot.brain.get('coffeeCount')
    msg.send "There have been #{rounds} rounds since records began.\n#{teas} cups of tea, and #{coffees} cups of coffee."

