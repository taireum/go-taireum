pragma solidity ^0.4.0;

//Member election, must be approved by all current members.
contract Member {

    struct Ballot {
        uint ticketNum;
        mapping(address => uint) voters;
    }

    //enode => Ballot
    mapping(string => Ballot) votes;

    mapping(address => uint) members;

    mapping(string => address) enodes;

    uint memberNum;

    event Vote(string enode,address voter);
    event Register(string enode,address register);

    //Funder build the contract.
    function Member(string enode) public{
        //register funder
        members[msg.sender] = 1;
        enodes[enode] = msg.sender;

        //funder vote to himself
        votes[enode].voters[msg.sender] = 1;
        votes[enode].ticketNum++;

        memberNum = 1;
    }

    //register to be member
    function register(string enode) public {
        if(members[enodes[enode]] == 1)
            revert("the enode had registered.");
        if(votes[enode].ticketNum <= 0)
            revert("the enode is not voted.");
        members[msg.sender] = 1;
        enodes[enode] = msg.sender;
        memberNum++;
        emit Register(enode,msg.sender);
    }

    function vote(string enode) public {
        if(votes[enode].voters[msg.sender] >= 1 )
            revert("you had voted the enode.");
        if(members[msg.sender] != 1)
            revert("Can not vote from unregistered address.");
        votes[enode].voters[msg.sender] = 1;
        votes[enode].ticketNum++;
        emit Vote(enode,msg.sender);
    }

    function isMember(string enode) constant public returns (bool result){
        result = false;
        if(votes[enode].ticketNum >= memberNum){
            result = true;
        }
    }
}