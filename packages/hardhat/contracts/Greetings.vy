# @version ^0.3.10
# A vyper contract equivalent to YourContract.sol

# State Variables
owner: public(immutable(address))
greeting: public(String[100])
premium: public(bool)
totalCounter: public(uint256)
userGreetingCounter: public(HashMap[address, uint256])

# Events
event GreetingChange:
    greetingSetter: indexed(address)
    newGreeting: String[100]
    premium: bool
    value: uint256

# Constructor
@external
def __init__(_owner: address):
    owner = _owner
    self.greeting = "Building Unstoppable Apps!!!"
    self.premium = False
    self.totalCounter = 0

# Functions
@external
@payable
def setGreeting(_newGreeting: String[100]):
    # Change state variables
    self.greeting = _newGreeting
    self.totalCounter += 1
    self.userGreetingCounter[msg.sender] += 1

    # Check if payment was sent
    if msg.value > 0:
        self.premium = True
    else:
        self.premium = False

    # Emit event
    log GreetingChange(msg.sender, _newGreeting, msg.value > 0, msg.value)

@external
def withdraw():
    # Only owner can withdraw
    assert msg.sender == owner, "Not the Owner"
    
    # Send all contract balance to owner
    send(owner, self.balance)

# Function to receive ETH
@external
@payable
def receive():
    pass

