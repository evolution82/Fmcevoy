#!/usr/bin/ruby
require 'pry'

Pry.config.print = proc {|output, value| output.puts "=> #{value.inspect}"}

class Machine < Struct.new(:statement, :environment)
    def step
        self.statement, self.environment = statement.reduce(environment)
    end

    def run
        while statement.reducible?
            puts "#{statement}, #{environment}" 
            step
        end
        puts "#{statement}, #{environment}" 
    end
end

class DoNothing
    def reducible?
        false 
    end

    def to_s
        "do-nothing"
    end

    def inspect
        "<<#{self}>>"
    end

    def ==(other_statement)
        other_statement.instance_of?(DoNothing)
    end
end

class Assign < Struct.new(:name, :expression)
    def reducible?
        true
    end

    def to_s
        "#{name} = #{expression}"
    end

    def inspect
        "<<#{self}>>"
    end

    def reduce(environment)
        if expression.reducible?
            [Assign.new(name, expression.reduce(environment)), environment]
        else
            [DoNothing.new(), environment.merge({name => expression})]
        end
    end

end

class If < Struct.new(:condition, :consequence, :alternative)
    def reducible?
        true 
    end

    def to_s
        "if(#{condition}) { #{consequence} } else { #{alternative} }"
    end

    def inspect
        "<<#{self}>>"
    end

    def reduce(environment)
        if condition.reducible?
            [If.new(condition.reduce(environment), consequence, alternative), environment]
        else
            case condition
            when Boolean.new(true)
                [consequence, environment]
            when Boolean.new(false)
                [alternative, environment]
            end
        end
    end
end

class Sequence < Struct.new(:first, :second)
    def reducible?
        true 
    end

    def to_s
        "#{first}; #{second}" 
    end

    def inspect
        "<<#{self}>>"
    end

    def reduce(environment)
        case first
        when DoNothing.new
            [second, environment]
        else
            reduced_first, reduced_environment = first.reduce(environment)
            [Sequence.new(reduced_first, second), reduced_environment]
        end
    end
end

class While < Struct.new(:condition, :body)
    def reducible?
        true 
    end

    def to_s
       "while (#{condition}) { #{body} }" 
    end

    def inspect
        "<<#{self}>>"
    end

    def reduce(environment)
        [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
    end
end

class Variable < Struct.new(:name)
    def reducible?
        true 
    end

    def to_s
        name.to_s
    end

    def inspect
        "<<#{self}>>"
    end

    def reduce(environment)
        environment[name]
    end

    def evaluate(environment)
        environment[name]
    end
end

class Number < Struct.new(:value)
    def reducible?
        false
    end

    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        self
    end
end

class Boolean < Struct.new(:value)
    def reducible?
        false
    end

    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        self
    end
end

class LessThan < Struct.new(:left, :right)
    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            LessThan.new(left.reduce(environment) , right)
        elsif right.reducible?
            LessThan.new(left, right.reduce(environment))
        else
            Boolean.new(left.value < right.value)
        end
    end

    def to_s
        "#{left} < #{right}"
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value) 
    end
end

class Add < Struct.new(:left,:right)
    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Add.new(left.reduce(environment), right)
        elsif right.reducible?
            Add.new(left, right.reduce(environment))
        else
            Number.new(left.value + right.value)
        end
    end

    def to_s
        "#{left} + #{right}"
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Number.new(left.evaluate(environment).value + right.evaluate(environment).value) 
    end
end

class Multiply < Struct.new(:left,:right)
    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Multiply.new(left.reduce(environment), right)
        elsif right.reducible?
            Multiply.new(left, right.reduce(environment))
        else
            Number.new(left.value * right.value)
        end
    end

    def to_s
        "#{left} * #{right}"
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Number.new(left.evaluate(environment).value * right.evaluate(environment).value) 
    end
end

exp =
Machine.new(
    Add.new(
        Multiply.new(Number.new(2), Number.new(3)),
        Multiply.new(Number.new(2), Number.new(3)),
    )
)
pry.binding
