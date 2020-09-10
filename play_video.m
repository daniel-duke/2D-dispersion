% clear; close all;
[filename, output_folder] = uigetfile({'*.avi';'*.mp4'},'Select video to play','OUTPUT/');
implay([output_folder filename]);