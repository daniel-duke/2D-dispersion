% clear; close all;
[filename, output_folder] = uigetfile({'*.mp4';'*.avi'},'Select video to play','OUTPUT/');
implay([output_folder filename]);