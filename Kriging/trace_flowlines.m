function[] = trace_flowlines(domain,n,dstep);


% Starting from mouse-clicked points on the specified DOMAIN [xmin xmax ymin ymax] 
% of a flowset, trace n flowlines at the distance step DSTEP in both directions 
% to the domain edge
%
% The program krigs the flow direction in the tracing procedure.
%
% Outputs:
% FL_i              matrix with the columns [x y thetak thetas C Cs Chik Chis];
% FL_click_pos      matrix whose columns [x y] are the clicked positions
%
% Example:          trace_flowlines([330 430 600 680],30,0.5);


load flowset
lin_visual(F,'r'); axis equal; axis(domain); hold on

global vg_params
load results/kriging_results R vg_params


for k = 1:n
    title(['Flowline ' num2str(k) ': click point'])
    % obtain mouse-click point
    intest = 0;
    while intest < 1
        [x0,y0] = ginput(1);
        title(['Flowline ' num2str(k) ': ' num2str(x0) ', ' num2str(y0)])
        pause(1)
        intest =  (x0>=domain(1)) & (x0<=domain(2)) & (y0>=domain(3)) & (y0<=domain(4));
        if intest == 0
            disp('Mouse click lies outside the domain. Click again!')
        end
    end
    %
    FL_click_pos(k,:) = [x0,y0];
    pos1(1,:) = [x0,y0]; pos2(1,:) = [x0,y0];
    %
    % trace in downstream direction
    intest = 1;
    i = 0;
    while intest > 0
        i = i + 1;
        % kriging
        [theta0k,theta0s,C0k,C0s,Chi0k,Chi0s] = krig_pos(F1(:,1),F1(:,2),F1(:,3),R,pos1(i,1),pos1(i,2));
        M1(i,:) = [theta0k theta0s C0k C0s Chi0k Chi0s];
        % find next position
        pos1(i+1,:) = pos1(i,:) + dstep*[sin(theta0k) cos(theta0k)];
        % does it lie in the domain?
        intest = (pos1(i+1,1)>=domain(1)) & (pos1(i+1,1)<=domain(2)) & (pos1(i+1,2)>=domain(3)) & (pos1(i+1,2)<=domain(4));
    end
    Mp1 = [pos1(1:i,:) M1(1:i,:)];
    %
    % trace in upstream direction
    intest = 1;
    i = 0;
    while intest > 0
        i = i + 1;       
        % kriging
        [theta0k,theta0s,C0k,C0s,Chi0k,Chi0s] = krig_pos(F1(:,1),F1(:,2),F1(:,3),R,pos2(i,1),pos2(i,2));
        M2(i,:) = [theta0k theta0s C0k C0s Chi0k Chi0s];
        % find next position
        pos2(i+1,:) = pos2(i,:) - dstep*[sin(theta0k) cos(theta0k)];
        % does it lie in the domain?
        intest = (pos2(i+1,1)>=domain(1)) & (pos2(i+1,1)<=domain(2)) & (pos2(i+1,2)>=domain(3)) & (pos2(i+1,2)<=domain(4));
    end
    Mp2 = [pos2(2:i,:) M2(2:i,:)];
    %
    % merge upstream and downstream results into single matrix, and write to output
    Mp = [ flipud(Mp2) ; Mp1 ];
    eval(['FL_' num2str(k) ' = Mp;'])
    %
    plot(Mp(:,1),Mp(:,2),'k')
end


save results/traced_flowlines_results FL*



