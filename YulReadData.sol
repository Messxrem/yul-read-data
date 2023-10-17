// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract YulReadData {

    uint[] array;
    mapping(address => uint) mapp;

    constructor() {
        array.push(10);
        array.push(20);
        mapp[address(this)] = 50;
    }

    function readStringFromMemory(string memory _str) external pure returns (bytes32 str) {
        assembly {
            let freeMemoryPointer := mload(64)
            str := mload(sub(freeMemoryPointer, 32))
        }
    }

    function readArrayFromMemory(uint[3] memory _array) external pure returns (uint el1, uint el2, uint el3) {
        assembly {
            let freeMemoryPointer := mload(64)
            el3 := mload(sub(freeMemoryPointer, 32))
            el2 := mload(sub(freeMemoryPointer, 64))
            el1 := mload(sub(freeMemoryPointer, 96))
        }
    }

    function readStringFromCalldata(string calldata _str) external pure returns (bytes32 startIn, bytes32 length, bytes32 str) {
        assembly {
            startIn  := calldataload(4)
            length := calldataload(add(4, startIn))
            str := calldataload(add(36, startIn))
        }
    }

    function readArrayFromCalldata(uint[3] memory _array) external pure returns (uint el1, uint el2, uint el3) {
        assembly {
            el1 := calldataload(4)
            el2 := calldataload(add(4, 32))
            el3 := calldataload(add(4, 64))
        }
    }

    function readDynamicArrayFromStorage() external view returns (uint length, uint el1, uint el2) {
        assembly {
            length := sload(0)
            let pos := keccak256(0, 32)
            el1 := sload(pos)
            let nextPos := add(pos, 1)
            el2 := sload(nextPos)
        }
    }

    function readMappingFromStorage(address key) external view returns (uint el) {
        bytes32 pos = keccak256(abi.encode(key, 1));
        assembly {
            el := sload(pos)
        }
    }

}