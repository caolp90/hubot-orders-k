# Hubot: hubot-hotbot

A Hubot script for Slack to pick who makes the coffee.

See [`src/hotbot.coffee`](src/hotbot.coffee) for full documentation.

## Installation

Add **hubot-hotbot** to your `package.json` file:

```json
"dependencies": {
  "hubot": ">= 2.5.1",
  "hubot-scripts": ">= 2.4.2",
  "hubot-hotbot": ">= 0.0.3",
  "hubot-slack": ">= 2.0.3",
}
```

Add **hubot-hotbot** to your `external-scripts.json`:

```json
["hubot-hotbot"]
```

Run `npm install`

## Sample Interaction

```
user1>> i want tea
hubot>> One vote for tea from user1 - that makes 1...

user2>> coffee please
hubot>> One vote for coffee from user2 - that makes 2...
...

user5>> i want :coffee:
hubot>> HOT DRINKS TIME! The winner is: user2! Good luck out there.

user1>> how many rounds?
hubot>> There have been 4 rounds since records began.
16 cups of tea, and 4 cups of coffee.
```

