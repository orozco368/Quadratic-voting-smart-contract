// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract ballot {

    struct Proposal{
        string option;
        uint256 numOfVotes;
    }

    struct Voter {
        address voterAddress;
        uint256 score;
    }

    mapping(uint256 => Proposal) _proposals; // mapping for proposals
    mapping(address => bool) _allowedVoters; // mapping for allowed voters
    mapping (address => Voter) _voters; // mapping of address to voter information
    address[] _votersList; // list of allowed voters addresses
    uint256[] _proposalList; // list of proposal numbers
    bool public _voteStarted = false;
    address _ballotOwner; // address of the person that deployed the contract
    uint256 _score = 0; // score for each voter
    string public _winner; // winner
    uint256 _votersLen = 0; // number of voters
    uint256 _mappingLen = 0; // number of proposals
    uint256 voteStartTime; // the time the vote is started
    uint256 public _duration; // the duration of the vote (minutes)

    event votingStarted(bool flag);
    event votingEnded(bool flag, string winner);

    // constructor that sets the block number and ballot owner
    constructor(uint256 score, uint256 duration) {
        _ballotOwner = msg.sender; // store the ballot owner
        _duration = duration * 60;
        _score = score;
    }

    // only the contract owner can add addresses to the ballot
    function addAddress (address addressToAdd) public onlyOwner {
        require(addressToAdd != _ballotOwner, "ballot owner cannot add itself to the list of voters");
        _allowedVoters[addressToAdd] = true;
        Voter memory voterToAdd = Voter(addressToAdd, _score);
        _voters[addressToAdd] = voterToAdd;
        _votersLen++;
        return;
    }

    // function to create a proposal
    function createProposal(uint256 proposalNum, string memory _option) public onlyOwner {
        // create prooposal struct with parameters
         Proposal memory newProposal = Proposal({
            option: _option,
            numOfVotes: 0
        });

        // add the proposal to the mapping
        _proposals[proposalNum] = newProposal;
        _proposalList.push(proposalNum);
        _mappingLen += 1;
    }

    // function that starts the vote and emits the event
    function startVote() public onlyOwner {
        require(_votersLen > 0 && _mappingLen > 0, "cannot start vote with 0 proposals or 0 people");
        _voteStarted = true;
        voteStartTime = block.timestamp; // Record the start time of the vote
        emit votingStarted(_voteStarted);
    }

    function endVote() public onlyOwner openThreshold returns(string memory proposal) {
        require(_voteStarted, "voting has not been started");

        Proposal memory max = _proposals[_proposalList[0]];
        // find proposal with max num of votes
        for (uint256 i = 0; i < _proposalList.length; i++) {
            if (_proposals[_proposalList[i]].numOfVotes > max.numOfVotes) {
                max = _proposals[_proposalList[i]];
            }
        }

        emit votingEnded(true, max.option);
        _winner = max.option;
        _voteStarted = false;

        return max.option;
    }

    // voter casts the vote
    function castVote(uint256 proposalNum, uint256 votesNum) public isVoteActive isValidVoter {
        uint256 voteScoreTotal = votesNum * votesNum;
        require(voteScoreTotal <= _voters[msg.sender].score, "not enough points to make vote");
        require(bytes(_proposals[proposalNum].option).length != 0, "invalid proposal number"); 
        _voters[msg.sender].score -= voteScoreTotal; // subtract the score from the voters total score
        _proposals[proposalNum].numOfVotes += voteScoreTotal; // add the score to the propsoal votes total
        
    }

    modifier onlyOwner() {
        require(msg.sender == _ballotOwner, "only ballot owner can call this function!");
        _;
    }

    modifier isValidVoter() {
        require(_allowedVoters[msg.sender], "not a valid voters");
        _;
    }

    modifier isVoteActive() {
        require(_voteStarted, "voting is over");
        _;
    }

    modifier openThreshold() {
        require(block.timestamp >= voteStartTime + _duration, "cannot end vote until threshold is over");
        _;
    }

}