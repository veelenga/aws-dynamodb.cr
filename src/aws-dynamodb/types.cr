require "json"

module Aws::DynamoDB::Types
  @[JSON::Serializable::Options(emit_nulls: true)]
  struct AttributeValue
    include JSON::Serializable

    # An attribute of type Binary
    #
    # ````
    # "B": "dGhpcyB0ZXh0IGlzIGJhc2U2NC1lbmNvZGVk"
    # ````
    @[JSON::Field(key: "B")]
    getter b : String?

    # An attribute of type Boolean
    #
    # ````
    # "BOOL": true
    # ````
    @[JSON::Field(key: "BOOL")]
    getter bool : Bool?

    # An attribute of type Binary Set
    #
    # ````
    # "BS": ["U3Vubnk=", "UmFpbnk=", "U25vd3k="]
    # ````
    @[JSON::Field(key: "BS")]
    getter bs : Array(String)?

    # An attribute of type List
    #
    # ```
    # "L": [{"S": "Cookies"}, {"S": "Coffee"}, {"N", "3.14159"}]
    # ```
    @[JSON::Field(key: "L")]
    getter l : Array(AttributeValue)?

    # An attribute of type Map
    #
    # ```
    # "M": {"Name": {"S": "Joe"}, "Age": {"N": "35"}}
    # ```
    @[JSON::Field(key: "M")]
    getter m : Hash(String, AttributeValue)?

    # An attribute of type Number
    #
    # ````
    # "N": "123.45"
    # ````
    @[JSON::Field(key: "N", converter: Aws::DynamoDB::Types::NConverter)]
    getter n : Float64?

    # An attribute of type Number Set
    #
    # ````
    # "NS": ["42.2", "-19", "7.5", "3.14"]
    # ````
    @[JSON::Field(key: "NS", converter: Aws::DynamoDB::Types::NNConverter)]
    getter ns : Array(Float64)?

    # An attribute of type Null
    #
    # ````
    # "NULL": true
    # ````
    @[JSON::Field(key: "NULL")]
    getter null : Bool?

    # An attribute of type String
    #
    # ````
    # "S": "Hello"
    # ````
    @[JSON::Field(key: "S")]
    getter s : String?

    # An attribute of type String Set
    #
    # ````
    # "SS": ["Giraffe", "Hippo" ,"Zebra"]
    # ````
    @[JSON::Field(key: "SS")]
    getter ss : Array(String)?

    def [](key) # ameba:disable Metrics/CyclomaticComplexity
      case key
      when "B"    then b
      when "BOOL" then bool
      when "BS"   then bs
      when "L"    then l
      when "M"    then m
      when "N"    then n
      when "NS"   then ns
      when "NULL" then null
      when "S"    then s
      when "SS"   then ss
      else
        raise ArgumentError.new("invalid key")
      end
    end
  end

  module NConverter
    def self.from_json(value : JSON::PullParser) : Float64
      value.read_string.to_f64
    end
  end

  module NNConverter
    def self.from_json(value : JSON::PullParser) : Array(Float64)
      values = [] of Float64
      value.read_array do
        values << value.read_string.to_f64
      end
      values
    end
  end

  alias TableDescription = NamedTuple(
    ItemCount: Int64,
    TableArn: String,
    TableName: String,
    TableStatus: String,
    TableSizeBytes: Int64,
  )

  alias ConsumedCapacity = NamedTuple(
    TableName: String,
    CapacityUnits: Float64?,
    ReadCapacityUnits: Float64?,
    WriteCapacityUnits: Float64?,
  )

  alias ItemCollectionMetrics = NamedTuple(
    ItemCollectionKey: Hash(String, AttributeValue)?,
    SizeEstimateRangeGb: Array(Float64)?,
  )

  PutItemOutput = NamedTuple(
    Attributes: Hash(String, AttributeValue)?,
    ConsumedCapacity: ConsumedCapacity?,
    ItemCollectionMetrics: ItemCollectionMetrics?,
  )

  GetItemOutput = NamedTuple(
    Item: Hash(String, AttributeValue)?,
    ConsumedCapacity: ConsumedCapacity?,
  )

  ListTablesOutput  = NamedTuple(TableNames: Array(String), LastEvaluatedTableName: String?)
  CreateTableOutput = NamedTuple(TableDescription: TableDescription)
  DeleteTableOutput = NamedTuple(TableDescription: TableDescription)
end
