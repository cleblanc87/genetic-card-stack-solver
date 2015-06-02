#cards 1-10
#2 piles 0 == 36, 1 == 360
#genome = 0000000000
#genome => phenotype
#

class CardStacker

	def initialize iter_count, population_size
		@target_sum = 36
		@target_product = 360

		@genome_length = 10
		@genome_max_value =  ("1" * @genome_length).to_i(2)

		@population_size = population_size
		@population = []

		create_population

 		iter_count.times do |i|
			determine_fitness
			selection
			crossover
			mutate
		end
		determine_fitness

		@population.each do |p|
			puts genome_to_phenotype(p)
		end

	end

	private

	def selection
		new_genes = @population
		new_genes.sort_by! do |k|
			k[:fitness]
		end
		@population = new_genes[0..(new_genes.length / 2 - 1)]
	end

	def fitness gene
		phenotype = genome_to_phenotype(gene)
		sum_diff = phenotype[:sum] - @target_sum
		product_diff = phenotype[:product] - @target_product

		fitness = ((sum_diff + product_diff ) / 2.0).round.abs

		if fitness == 0
			puts "Solution Found!"
			puts phenotype.inspect
			exit
		end

		fitness
	end

	def crossover
		p_len = @population.length

		p_len.times do |i|
			cross_over_partner = rand(0..(@population.length-1))

			gene_a = @population[i]
			gene_b = @population[cross_over_partner]

			gene_crossed_a = gene_a[:gene][0..(@genome_length/2 - 1)] + gene_b[:gene][(@genome_length/2)..(@genome_length-1)]
			gene_crossed_b = gene_b[:gene][0..(@genome_length/2 - 1)] + gene_a[:gene][(@genome_length/2)..(@genome_length-1)]

			@population[i][:gene] = gene_crossed_a
			@population[cross_over_partner][:gene] = gene_crossed_b
			#@population.push({gene: gene_crossed_a, fitness: 100})
			@population.push({gene: gene_a[:gene], fitness: 1111111})
		end
	end

	def mutate
		if rand > 0.5
			@population.each do |p|
				rand_bit = rand(0..p[:gene].length-1)
				p[:gene][rand_bit] = (p[:gene][rand_bit].to_i ^ 1).to_s
			end
		end
	end

	def create_population
		@population_size.times do
			@population.push({gene: random_genome, fitness: 0})
		end
	end


	def determine_fitness
		@population.each_with_index do |v, i|
			@population[i][:fitness] = fitness(v)
		end
	end

	public

	def genome_to_phenotype gene_object
		#take gene an split into two piles
		#puts "gene #{gene}"
		gene = gene_object[:gene]
		pile_0 = []
		pile_1 = []

		gene.split('').each_with_index do |n, i|
			if n == "0"
				pile_0.push(i + 1)
			else
				pile_1.push(i + 1)
			end
		end

		sum = pile_0.inject(&:+) || 0
		product = pile_1.inject(&:*) || 0

		if false
			puts "pile 0: #{pile_0}"
			puts "pile 0 sum : #{ sum }"

			puts "pile 1: #{pile_1}"
			puts "pile 1 product : #{ product }"
		end

		{pile_0: pile_0, pile_1: pile_1, sum: sum, product: product}
	end


	def random_genome
		rand(0..@genome_max_value).to_s(2).rjust(@genome_length, "0")
	end
end

cs = CardStacker.new(200, 100)
#puts cs.random_genome

#cs.genome_to_phenotype("0100010010")


# 0 0 0 0 0 0 0 0 1 0
# 0 1 ...
# 1 2 3 4 5 6 7 8 9 10



