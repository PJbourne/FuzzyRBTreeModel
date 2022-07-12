%%CODE OCEAN algorithm

clear all; close all; clc;
format bank;

filename = '/data/Ibovespa_data.xls';
file = xlsread(filename);

stepsAhead = 1;
noutofsample = 11;

file = xlsread(filename);
Data = (file((1:end),1));

[RMSE, RMSEoNaive, Rquad, Mae, fore] = fuzzyoutOfSampleTest('FuzzyRBTModel',Data, stepsAhead, noutofsample);

aux = [RMSE RMSEoNaive Rquad Mae];
        
ttable = [fore'];   
testtable = round(ttable)