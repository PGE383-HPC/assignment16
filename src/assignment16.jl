#!/usr/bin/env julia

# Copyright 2022 John T. Foster
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module assignment16

using CSV
using Tables
using Distributed

@everywhere using DistributedArrays

function read_data_file(filename::String)
    CSV.File(filename; header=false, skipto=6) |> Tables.matrix
end

function parse_width_and_thickness(filename::String)
    l::String = ""
    for (i, line) in enumerate(eachline(filename))
        l = line
        if i == 3
          break
        end
   end
   first_split_string = split(l, ",")
   width = parse(Float64, strip(split(first_split_string[3], "=")[2], '"'))
   thickness = parse(Float64, split(split(first_split_string[4], "=")[2], '"')[1])
   (width, thickness)
end

function convert_to_true_strain(basename::String)
    filename = basename*".$(myid()).$(nprocs()).csv"
    data =  read_data_file(filename)
    log.(1 .+ data[:, 3])
end

function convert_to_true_stress(basename::String)
    filename = basename*".$(myid()).$(nprocs()).csv"
    width, thickness =  parse_width_and_thickness(filename)
    data =  read_data_file(filename)
    data[:, 4] / width / thickness .* (1 .+ data[:, 3])
end

function trapz(strain::AbstractArray, stress::AbstractArray)
    0.5 .* sum((stress[2:end] + stress[1:(end-1)]) .*  
               (strain[2:end] - strain[1:(end-1)]))
end

function read_partitioned_data(basename::String)
    #######################
    #### Add Code Here ####
    #######################
    #
    #should return 
    #strain::DArray, stress::DArray
end

function compute_toughness_parallel(basename::String)
    my_strain, my_stress = read_partitioned_data(basename)
    trapz(my_strain, my_stress)
end

if abspath(PROGRAM_FILE) == @__FILE__
    addprocs(parse(Int, ARGS[1]), exeflags="--project")
    using assignment16
    compute_toughness_parallel(ARGS[2]) |> print
end

export compute_toughness_parallel

end

