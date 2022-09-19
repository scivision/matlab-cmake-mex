function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = "check";
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues),formattedDisplayText(issues.Issues))
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
assertSuccess(runtests('mex/'))
end
