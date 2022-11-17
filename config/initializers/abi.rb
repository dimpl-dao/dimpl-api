module ABI
    extend self
    def to_hash(abi)
        hash = {}
        abi.each do |function|
            hash[function["signature"].to_sym] = function.with_indifferent_access
        end
        return hash
    end
    DIMPL_ERC20 = ABI.to_hash(JSON.parse(File.read('config/abi/DimplERC20.json'))["abi"])
    DIMPL_ESCROW = ABI.to_hash(JSON.parse(File.read('config/abi/DimplEscrow.json'))["abi"])
    DIMPL_GOVERNOR = ABI.to_hash(JSON.parse(File.read('config/abi/DimplGovernor.json'))["abi"])
end