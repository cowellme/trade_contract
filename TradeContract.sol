// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract TradeContract {

     // Определение структуры для товара
    struct Offer {
        string name; // Название товара
        string inn; // ИНН исполнителя
        string task; // Задача
        bool stoped; // Остановка времени контракта
        bool completed; // Выполнение контракта
        uint256 time; // Количество товара
        address owner; // Владелец товара
    }

    // Массив товаров
    mapping(address => Offer[]) public offers;


    function createOffer(string memory _name, uint256 _time, string memory _inn, string memory _task) public {
        Offer memory offer = Offer({
            name: _name,
            time: _time,
            owner: msg.sender,
            inn: _inn,
            task: _task,
            stoped: false,
            completed: false
        });

        offers[msg.sender].push(offer);
    }

    function getOffer(address _owner) public view returns (Offer[] memory) {
        return offers[_owner];
    }

    function deleteOffer(address _owner, uint index) public {
        require(_owner == msg.sender, "Only owner can delete product");

        if (index >= offers[_owner].length) {
            revert("Invalid index");
        } else {
            delete offers[_owner][index];
        }
    }

    function completeOffer(address _seller, address _buyer, uint index) public {
       require(_seller == offers[_buyer][index].owner, "Seller is not owner of the product");
       offers[_buyer][index].completed = true;
    }

    function changeCompletedStatus(address _owner, uint index, bool newSoldStatus) public {
      require(_owner == msg.sender, "Only owner can change status");
      offers[_owner][index].completed = newSoldStatus;
   }
}