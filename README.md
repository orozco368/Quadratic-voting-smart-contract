
# Quadratic Voting Smart Contract

This is a smart contract that faciliates a quadratic voting system. It allows for an entity to deploy the contract where they are the ballot owner and are facilitating the vote. The ballot owner will communicate with the voters off the chain about the different proposals (options) and when the vote begins.

In quadratic voting, each vote is squared so 2 votes counts as a score of 4 votes (2 * 2), 3 counts as 9 (3 * 3), etc.




## Features

- Only the ballot owner can add addresses to the ballot but can not add itself
- Only the ballot owner can create proposals (voting options)
- Only the ballot owner can start and end the vote. 
- The voters can only cast votes
- There must be at least one voter and one created proposal in order for the ballot owner to start the vote
- The ballot owner can not end the vote until the duration threshold has passed (in minutes)


## Tools
Remix IDE
https://remix.ethereum.org/
## How to Run
1. First, add the score you want to give each voter and the duration (in minutes) to deploy the contract. In this example I am deploying with a score of 16 and duration of 1 minute (to keep it simple). At the top left there is "Account" and that address will be the ballot owner.
![Deploy](https://i.imgur.com/tndyVt8.png)

After deployment, at the bottom left you will see the contract.
![After deploy](https://i.imgur.com/PwuNZQa.png)

2. Next, the ballot owner can add proposals or add addresses. I will add addresses first. In Remix, you can change addresses at the top left. There is a dropdown menu at "Account". You can change accounts and copy the account address.
![Drop down menu](https://i.imgur.com/D8NVKlz.png)

The ballot owner will then add the address in the "addAddress" function of the contract. Multiple addresses can be added.
![add address](https://i.imgur.com/FmlbATo.png)

3. Next, the ballot owner will create proposals. The ballot owner does this with the createProposal function. The ballot owner provides a proposal number and a string which can represent the description.
![create proposal](https://i.imgur.com/aLbHp9p.png)

4. Next, the ballot owner will start the vote once there is at least one proposal created and one voter address added to the ballot. The ballot owner can start the vote by simply pressing the startVote function.
![start vote](https://i.imgur.com/yXwmTJd.png)

5. Once the vote is started, the voters, not including the ballot owner, will vote. The voter will use the castVote function where the proposal number is provided along with the amount of votes they want to use for the chosen proposal.

Here, the account address can be changed in Remix, using the account dropdown menu, to the address that was added by the ballot owner. The voter here is voting for proposal 1 with 2 votets. These 2 votes will be reflected as a score of 4 (2 * 2) votes because of quadratic voting. The voter will do this for any proposal numbers they wish to vote for.
![cast vote 1](https://i.imgur.com/RefFis4.png)

![cast vote 2](https://i.imgur.com/FhGqqjk.png)

6. Once the ballot owner wants to end the vote, they can simply end the vote using the endVote function. The endVote function will return the winner. The vote will not end until the duration threshold has passed.

In Remix, you can switch back the ballot owner address using the account drop down menu. 
![end vote](https://i.imgur.com/2U61lCU.png)

Anyone can also check the winner by calling the _winner variable. They can also check if the voting has started or ended by calling the _votingStarted variable and check the _duration (will be in seconds). 
![_winner](https://i.imgur.com/z0kEOVs.png)

