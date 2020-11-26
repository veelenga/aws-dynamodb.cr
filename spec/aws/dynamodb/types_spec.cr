require "../../spec_helper"

module Aws::DynamoDB::Types
  describe AttributeValue do
    it "serializes binary" do
      b = "dGhpcyB0ZXh0IGlzIGJhc2U2NC1lbmNvZGVk"
      AttributeValue.from_json({B: b}.to_json).b.should eq(b)
    end

    it "serializes boolean as true" do
      bool = true
      AttributeValue.from_json({BOOL: bool}.to_json).bool.should eq(bool)
    end

    it "serializes boolean as false" do
      bool = false
      AttributeValue.from_json({BOOL: bool}.to_json).bool.should eq(bool)
    end

    it "serializes binay set" do
      bs = ["U3Vubnk=", "UmFpbnk=", "U25vd3k="]
      AttributeValue.from_json({BS: bs}.to_json).bs.should eq(bs)
    end

    it "serializes list" do
      l = [{"S": "Cookies"}, {"S": "Coffee"}, {"N": "3.14159"}]
      res = AttributeValue.from_json({L: l}.to_json).l
      res.should_not be_nil

      res = res.not_nil!
      res.size.should eq 3
      res[0].s.should eq "Cookies"
      res[1].s.should eq "Coffee"
      res[2].n.should eq 3.14159
    end

    it "serializes map" do
      m = {"Name": {"S": "Joe"}, "Age": {"N": "35"}}
      res = AttributeValue.from_json({M: m}.to_json).m
      res.should_not be_nil

      res = res.not_nil!
      res["Name"].s.should eq "Joe"
      res["Age"].n.should eq 35
    end

    it "serializes number" do
      n = "123.45"
      AttributeValue.from_json({N: n}.to_json).n.should eq(n.to_f)
    end

    it "serializes number set" do
      ns = ["42.2", "-19", "7.5", "3.14"]
      AttributeValue.from_json({NS: ns}.to_json).ns
        .should eq(ns.map(&.to_f))
    end

    it "serializes null as true" do
      null = true
      AttributeValue.from_json({NULL: null}.to_json).null.should eq(null)
    end

    it "serializes null as false" do
      null = false
      AttributeValue.from_json({NULL: null}.to_json).null.should eq(null)
    end

    it "serializes string" do
      s = "Hello"
      AttributeValue.from_json({S: s}.to_json).s.should eq(s)
    end

    it "serializes string set" do
      ss = ["Giraffe", "Hippo", "Zebra"]
      AttributeValue.from_json({SS: ss}.to_json).ss.should eq(ss)
    end

    describe "#[]" do
      it "returns B" do
        b = "dGhpcyB0ZXh0IGlzIGJhc2U2NC1lbmNvZGVk"
        value = AttributeValue.from_json({B: b}.to_json)
        value["B"].should eq(value.b)
      end

      it "returns BOOL" do
        bool = true
        value = AttributeValue.from_json({BOOL: bool}.to_json)
        value["BOOL"].should eq(value.bool)
      end

      it "returns BS" do
        bs = ["U3Vubnk=", "UmFpbnk=", "U25vd3k="]
        value = AttributeValue.from_json({BS: bs}.to_json)
        value["BS"].should eq(value.bs)
      end

      it "returns S" do
        l = [{"S": "Cookies"}, {"S": "Coffee"}, {"N": "3.14159"}]
        value = AttributeValue.from_json({L: l}.to_json)
        value["L"].should eq(value.l)
      end

      it "returns M" do
        m = {"Name": {"S": "Joe"}, "Age": {"N": "35"}}
        value = AttributeValue.from_json({M: m}.to_json)
        value["M"].should eq(value.m)
      end

      it "returns N" do
        n = "123.45"
        value = AttributeValue.from_json({N: n}.to_json)
        value["N"].should eq(value.n)
      end

      it "serializes number set" do
        ns = ["42.2", "-19", "7.5", "3.14"]
        value = AttributeValue.from_json({NS: ns}.to_json)
        value["NS"].should eq(value.ns)
      end

      it "serializes null as true" do
        null = true
        value = AttributeValue.from_json({NULL: null}.to_json)
        value["NULL"].should eq(value.null)
      end

      it "serializes string" do
        s = "Hello"
        value = AttributeValue.from_json({S: s}.to_json)
        value["S"].should eq(value.s)
      end

      it "serializes string set" do
        ss = ["Giraffe", "Hippo", "Zebra"]
        value = AttributeValue.from_json({SS: ss}.to_json)
        value["SS"].should eq(value.ss)
      end

      it "raises if key is invalid" do
        expect_raises(ArgumentError, "invalid key") do
          AttributeValue.from_json({B: "1"}.to_json)["invalid_key"]
        end
      end
    end
  end
end
