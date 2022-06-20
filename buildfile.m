function plan = buildfile
plan = buildplan(localfunctions);
end

function compileTask(context)
rootFolder = context.Plan.RootFolder;

mex(fullfile(matlabroot, "extern/examples/refbook","matrixMultiply.c"), ...
"-outdir", rootFolder, ...
"-lmwblas")

mex("-client", "engine", fullfile(rootFolder, "engine/engdemo.c"), ...
"-outdir", rootFolder)

mex("-client", "engine", fullfile(rootFolder, "engine/eng_demo.cpp"), ...
"-outdir", rootFolder)

fc = mex.getCompilerConfigurations('fortran');
if(~isempty(fc))
  mex("-client", "engine", fullfile(rootFolder, "engine/eng_demo.F90"), ...
  "-outdir", rootFolder)
end

end

function testTask(~)
assertSuccess(runtests)
end
