module LandTitle::Management {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a land title with its metadata.
    struct Land has store, key {
        land_id: u64,           // Unique identifier for the land
        location: vector<u8>,   // Location data (e.g., coordinates or address)
        size: u64,              // Size of the land (in square meters)
        current_owner: address, // Current owner's address
    }

    /// Function to register new land with a unique land ID.
    public fun register_land(
        owner: &signer, 
        land_id: u64, 
        location: vector<u8>, 
        size: u64
    ) {
        let land = Land {
            land_id,
            location,
            size,
            current_owner: signer::address_of(owner),
        };
        move_to(owner, land);
    }

    /// Function to transfer land ownership from one address to another.
    public fun transfer_land_ownership(
        owner: &signer, 
        new_owner: address, 
        land_id: u64
    ) acquires Land {
        let current_owner = signer::address_of(owner);

        // Access the land by the current owner's address
        let land = borrow_global_mut<Land>(current_owner);

        // Ensure the caller is the current owner
        assert!(land.current_owner == current_owner, 101, b"Only the current owner can transfer ownership.");

        // Update the land's ownership
        land.current_owner = new_owner;
    }

    /// Function to verify the current owner of a land by its land_id.
    public fun verify_ownership(
        land_id: u64, 
        owner: address
    ): address acquires Land {
        let land = borrow_global<Land>(owner);
        land.current_owner
    }
}
