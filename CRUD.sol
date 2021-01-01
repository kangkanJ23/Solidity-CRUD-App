pragma solidity ^0.6.0;

contract CRUD {
    
    address private owner;
    
    constructor() public {
        owner = msg.sender;   
    }
    
    struct Country {
        string CountryName;
        string PresidentName;
        uint256 Population;
    }
    
    Country[] public Countries;
    uint private totalCountries;
    
    modifier ownerOnly{
        require(msg.sender == owner);
        _;
    }
    
    event CountryEvent(string countryName , string leader, uint256 population);
   
    event LeaderUpdated(string countryName , string leader);

    event CountryDelete(string countryName);
    
    //CREATE
    function addCountry(string memory countryName, string memory presidentName, uint256 countryPopulation) public ownerOnly {
        Countries.push(Country(countryName,presidentName,countryPopulation));
        totalCountries++;
        emit CountryEvent(countryName, presidentName, countryPopulation);
    }
    
    //READ
    function getCountry(string calldata countryName) external view returns(string memory _countryName, string memory _presidentName, uint256 _Population) {
        for(uint i=0; i<totalCountries; i++) {
            if(stringCompare(Countries[i].CountryName,countryName)){
                return (Countries[i].CountryName, Countries[i].PresidentName, Countries[i].Population);
            }
        }
        revert('No country found');
    }
    
    //UPDATE 
    function updateLeader(string memory _countryName, string memory _presidentName) public ownerOnly returns(bool){
        for(uint i=0; i<totalCountries; i++) {
            if(stringCompare(Countries[i].CountryName,_countryName)){
                Countries[i].PresidentName = _presidentName ;
                emit LeaderUpdated(_countryName, _presidentName);
                return true;
            }        
        }
        return false;    
    }
    
    //DELETE
    function deleteCountry(string memory _countryName) public ownerOnly returns(bool) {
        require(totalCountries > 0);
        for(uint i=0; i<totalCountries; i++) {
            if(stringCompare(Countries[i].CountryName,_countryName)){
                Countries[i] = Countries[totalCountries - 1]; 
                Countries.pop();
                totalCountries--; 
                emit CountryDelete(_countryName);
                return true;
            }        
        }
        return false;
    }
    
    function stringCompare(string memory first, string memory second) internal pure returns(bool) {
        bytes32 firstStringByteHash = keccak256(abi.encode(first));
        bytes32 secondStringByteHash = keccak256(abi.encode(second));
        return firstStringByteHash == secondStringByteHash; 
    } 
    
    function getTotalCountry() public view returns(uint ) {
        return totalCountries;
    }
}
