function rgbPercent = colorExchange(r,g,b)
    % rgbToPercent - 将 RGB 值从 0-255 转换为百分制形式
    rgbValues = [r,g,b];
    % 输入参数检查
    if size(rgbValues, 2) ~= 3
        error('输入必须是一个或多个 RGB 值');
    end
    
    if any(rgbValues > 255) || any(rgbValues < 0)
        error('RGB 值必须在 0 到 255 之间');
    end

    % 转换 RGB 值
    rgbPercent = (rgbValues / 255) ;

    % 为输出格式化为百分比形式
    disp(rgbPercent);
end
