clear;
clc;

simple1=SimpleEventClass(1);
simple2=SimpleEventClass(2);

sec1=SecondEventClass(simple1,3);
sec2=SecondEventClass([simple1,simple2],4);
sec3=SecondEventClass([sec1,sec2],5);

simple2.Prop1=10;
simple1.Prop1=10;

simple2.Prop1=13;
simple1.Prop1=13;