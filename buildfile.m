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
out_dir = tempdir;

example_dir = fullfile(matlabroot, "extern/examples");

mex(fullfile(example_dir, "refbook/matrixMultiply.c"), "-outdir", out_dir, "-lmwblas")
mex(fullfile(example_dir, "cpp_mex/arrayProduct.cpp"), "-outdir", out_dir)

mex("-client", "engine", fullfile(rootFolder, "engine/engdemo.c"), "-outdir", out_dir)
mex("-client", "engine", fullfile(rootFolder, "engine/eng_demo.cpp"), "-outdir", out_dir)

fc = mex.getCompilerConfigurations('fortran');
if isempty(fc)
  warning("Fortran MEX compiler not available")
  return
end

mex("-client", "engine", fullfile(rootFolder, "engine/eng_demo.F90"), ...
"-outdir", out_dir)

end

function testTask(~, test_dir, test_name, bin_dir)
arguments
  ~
  test_dir (1,1) string = "mex/"
  test_name (1,1) string = "*"
  bin_dir string {mustBeScalarOrEmpty} = tempdir;
end

  addpath(bin_dir)

  r = runtests(test_dir, Name=test_name);

  assert(~isempty(r), 'No tests were run.')

  if sum([r.Incomplete]) ~= 0
      warning("Some tests were skipped.")
      exit(77)
  end

  assertSuccess(r)
end
