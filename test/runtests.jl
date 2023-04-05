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
using Test, Pkg
using Distributed
addprocs(3, exeflags="--project")
using assignment16

basename_path = dirname(@__FILE__)*"/../data/data" 

@testset "Test on 4 processors" begin
    ans = compute_toughness_parallel(basename_path)
    @test isapprox(ans, 70836.1434834513, atol=1.0e-3)
end

@testset "Test on 3 processors" begin
    rmprocs([4])
    ans = compute_toughness_parallel(basename_path)
    @test isapprox(ans, 70836.1434834513, atol=1.0e-3)
end

@testset "Test on 2 processors" begin
    rmprocs([4])
    ans = compute_toughness_parallel(basename_path)
    @test isapprox(ans, 70836.1434834513, atol=1.0e-3)
end
