// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleDAO {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }

    address public owner;
    mapping(address => bool) public members;
    Proposal[] public proposals;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(address voter, uint256 proposalId);
    event ProposalExecuted(uint256 proposalId);

    constructor(address[] memory initialMembers) {
        owner = msg.sender;
        for (uint i = 0; i < initialMembers.length; i++) {
            members[initialMembers[i]] = true;
        }
    }

    function addMember(address newMember) public onlyOwner {
        members[newMember] = true;
    }

    function removeMember(address member) public onlyOwner {
        members[member] = false;
    }

    function createProposal(string memory description) public onlyMember {
        proposals.push(Proposal({
            description: description,
            voteCount: 0,
            executed: false
        }));
        emit ProposalCreated(proposals.length - 1, description);
    }

    mapping(uint256 => mapping(address => bool)) public votes;

    function vote(uint256 proposalId) public onlyMember {
        require(proposalId < proposals.length, "Invalid proposal");
        require(!votes[proposalId][msg.sender], "Already voted");

        votes[proposalId][msg.sender] = true;
        proposals[proposalId].voteCount += 1;

        emit Voted(msg.sender, proposalId);
    }

    function executeProposal(uint256 proposalId) public onlyOwner {
        require(proposalId < proposals.length, "Invalid proposal");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Already executed");
        require(proposal.voteCount > 0, "No votes");

        // Ici tu pourrais mettre la logique d’exécution
        proposal.executed = true;

        emit ProposalExecuted(proposalId);
    }

    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 voteCount, bool executed) {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.description, proposal.voteCount, proposal.executed);
    }
}
