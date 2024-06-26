function [Q] = GramSchmidt(V)
%GRAMSCHMIDT Summary of this function goes here
%   Detailed explanation goes here
[m, n] = size(V);  % m是向量维度，n是向量个数

Q = zeros(m, n);  % 初始化一个空的正交化矩阵Q，大小与V相同
R = zeros(n, n);  % 初始化一个空的上三角矩阵R，用于存储正交化过程中的投影系数

for k = 1:n
    % 取出第k个向量
    v = V(:, k);
    
    % 对于第k个向量，与前k-1个正交化
    for j = 1:k-1
        % 计算投影系数
        R(j, k) = Q(:, j)' * v;
        % 从v中减去投影
        v = v - R(j, k) * Q(:, j);
    end
    
    % 计算第k个正交化向量
    R(k, k) = norm(v);  % 更新R的对角元素为向量的范数
    Q(:, k) = v / R(k, k);  % 归一化得到第k个正交化向量
end

end

