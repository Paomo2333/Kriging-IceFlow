function[] = lin_visual(F,colour)

% Plot a map of the lineaments in the flowset lineament matrix F.
% A point is ploted to mark the start position (Xstart, Ystart) of each lineament.
% The input matrix F has the five-column structure:
%         1           2      3      4    5   
% F = [ lineament_ID Xstart Ystart Xend Yend ];
% Each row of F contains values for one lineament.
% COLOUR is MATLAB's standard colour: e.g. 'k' = black, 'r' = red
% Example:  lin_visual(F,'r')

L = length(F(:,1));
for i = 1:L
    plot( [F(i,2),F(i,4)] , [F(i,3),F(i,5)] , colour)
    hold on
    plot( F(i,2), F(i,3) , ['.' colour] )
end
xlabel('x'); ylabel('y')


