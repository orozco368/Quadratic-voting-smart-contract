
# Quadratic Voting Smart Contract

This is a smart contract that faciliates a quadratic voting system. It allows for an entity to deploy the contract where they are the ballot owner and are facilitating the vote. The ballot owner will communicate with the voters off the chain about the different proposals (options) and when the vote begins.

In quadratic voting, each vote is squared so 2 votes counts as a score of 4 votes (2 * 2), 3 counts as 9 (3 * 3), etc.




## Features

- Only the ballot owner can add addresses to the ballot but can not add itself
- Only the ballot owner can create proposals (voting options)
- Only the ballot owner can start and end the vote. 
- The voters can only vote
- There must be at least one voter and one created proposal in order for the ballot owner to start the vote


## Tools
Remix IDE
https://remix.ethereum.org/
## How to Run
1. First, add the score you want to give each voter and deploy the contract. In this example I am deploying with a score of 16. At the top left there is "Account" and that address will be the ballot owner.
![Deploy](https://i.imgur.com/j8BuEPF.png)

After deployment, at the bottom left you will see the contract.
![After deploy](https://i.imgur.com/WhBygSt.png)

2. Next, the ballot owner can add proposals or add addresses. I will add addresses first. In Remix, you can change addresses at the top left. There is a dropdown menu at "Account". You can change accounts and copy the account address.
![Drop down menu](https://i.imgur.com/D8NVKlz.png)

The ballot owner will then add the address in the "addAddress" function of the contract.
![add address](https://i.imgur.com/nlqvXYQ.png)

3. Next, the ballot owner will create proposals. The ballot owner does this by the createProposal function. The ballot owner provides a proposal number and a string which can represent the description.
![create proposal](https://i.imgur.com/RC6BrH6.png)

4. Next, the ballot owner will start the vote once there is at least one proposal created and one voter address added to the ballot. The ballot owner can start the vote by simply pressing the startVote function.
![start vote](https://i.imgur.com/1rAXlzJ.png)

5. Once the vote is started, the voters, not including the ballot owner, will vote. The voter will use the castVote function where the proposal number is provided along with the amount of votes they want to use for the chosen proposal.

Here, the account address can be changed in Remix, using the account dropdown menu, to the address that was added by the ballot owner. The voter here is voting for proposal 1 with 2 votets. These 2 votes will be reflected as a score of 4 (2 * 2) votes because of quadratic voting. The voter will do this for any proposal numbers they wish to vote for.
![cast vote 1](https://i.imgur.com/fb3i1Qr.png)

![cast vote 2](https://i.imgur.com/BGkXGMW.png)

6. Once the ballot owner wants to end the vote, they can simply end the vote using the endVote function. The endVote function will return the winner. 

In Remix, you can switch back the ballot owner address using the account drop down menu. 
![end vote](https://i.imgur.com/lXfx2TA.png)

Anyone can also check the winner by calling the _winner variable and they can also check if the voting has started or ended by calling the _votingStarted variable. 
![_winner](https://i.imgur.com/KXgj06d.png)

