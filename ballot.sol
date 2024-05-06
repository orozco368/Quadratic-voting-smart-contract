// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract ballot {

    struct Proposal{
        string option;
        uint256 numOfVotes;
    }

    struct Voter {
        address voterAddress;
        bool hasVoted;
        uint256 score;
    }

    mapping(uint256 => Proposal) _proposals; // mapping for proposals
    mapping(address => bool) _allowedVoters; // mapping for allowed voters
    mapping (address => Voter) _voters; // mapping of address to voter information
    address[] _votersList; // list of allowed voters addresses
    Proposal[] _proposalList;
    uint256 public _blockNum;
    bool public _voteStarted = false;
    uint256 _mappingLen = 0;
    uint256 _votersLen = 0;
    address _ballotOwner; // address of the person that deployed the contract
    uint256 internal _duration = 0;
    uint256 _score = 0;
    string public _winner;

    event votingStarted(bool flag);
    event votingEnded(bool flag, string winner);
    event ValueSet(string option, uint256 score);

    // constructor that sets the block number and ballot owner
    constructor(uint256 score) {
        _blockNum = block.number; // store the block number
        _ballotOwner = msg.sender; // store the ballot owner
        //_duration = duration;
        _score = score;
    }

    // only the contract owner can add addresses to the ballot
    function addAddress (address addressToAdd) public onlyOwner {
        require(addressToAdd != _ballotOwner, "ballot owner cannot add itself to the list of voters");
        _allowedVoters[addressToAdd] = true;
        Voter memory voterToAdd = Voter(addressToAdd, false, 20);
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
        _proposalList.push(newProposal);
        _mappingLen += 1;


    }

    // function that starts the vote and emits the event
    function startVote() public onlyOwner {
        require(_votersLen > 0 && _mappingLen > 0, "cannot start vote with 0 proposals or 0 people");
        _voteStarted = true;
        emit votingStarted(_voteStarted);
    }

    function endVote() public onlyOwner returns(string memory proposal) {
        //require(block.number >= _blockNum + _duration, "voting is not over");

        require(_voteStarted, "voting has not been started");

        Proposal memory max = _proposalList[0];
        for (uint256 i = 0; i < _proposalList.length; i++) {
            emit ValueSet(_proposalList[i].option,_proposalList[i].numOfVotes);
            if (_proposalList[i].numOfVotes > max.numOfVotes) {
                
                max = _proposalList[i];
            }
        }

        emit votingEnded(true, max.option);
        _winner = max.option;

        return max.option;
        

    }

    function getProposal(uint256 num) external view returns (string memory) {
        return _proposals[num].option;
    }

    // return the start block num
    function getBlockNum() public view returns(uint256 blockNum) {
        return _blockNum;
    }

    function getDuration() public view returns(uint256 duration) {
        return _duration;
    }

    function getVotersLen() public view returns(uint256 length){
        return _votersLen;
    }

    function isVoterAllowed(address voter) public view returns(bool flag) {
        return _allowedVoters[voter];
    }

    function getCurrentBlockNum() public view returns (uint256 current) {
        return block.number;
    }

    function castVote(uint256 proposalNum, uint256 votesNum) public isVoteActive isValidVoter {
        uint256 voteScoreTotal = votesNum * votesNum;
        require(voteScoreTotal <= _voters[msg.sender].score, "not enough points to make vote");
        _voters[msg.sender].score -= voteScoreTotal; // subtract the score from the voters total score
        //_proposals[proposalNum].numOfVotes += voteScoreTotal; // add the score to the propsoal votes total
        _proposalList[proposalNum -1].numOfVotes += voteScoreTotal;
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
        //require(block.number < _blockNum + _duration && _voteStarted, "voting is over");
        require(_voteStarted, "voting is over");
        _;
    }
















}