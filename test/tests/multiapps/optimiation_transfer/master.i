[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 20
  xmax = 1
  ymax = 2
[]

[Variables]
  [response]
  []
[]

[Kernels]
  #user kernel coverage = no in PROBLEM
  [null_kernel]
    type = NullKernel
    variable = response
  []
[]

[FormFunction]
  type = QuadraticMinimize
  initial_condition = '5 8 1'
  optimization_vpp = 'opt_results'
  optimization_results = 'fixme_lynn_want_to_use_other_vpp'
  objective = 1.0
  solution = '1 2 3'
[]

[Executioner]
  type = Optimize
  petsc_options_iname = '-tao_ntr_min_radius -tao_ntr_max_radius -tao_ntr_init_type'
  petsc_options_value = '0 1e16 constant'
  solve_on = none
[]

[MultiApps]
  [full_solve]
    type = FullSolveMultiApp
    execute_on = timestep_begin
    input_files = sub.i
    clone_master_mesh = true
  []
[]

[Transfers]
  [toSub]
    type = OptimizationTransfer
    multi_app = full_solve

    optimization_vpp = opt_results
    to_control = optimizationSamplerReceiver
    # initial conditions?
    #vector postprocessor to use    get ref to vector pp vector name and post processor name
  []
  [fromSub]
    type = MultiAppCopyTransfer
    direction = from_multiapp
    source_variable = temperature
    variable = response
    multi_app = full_solve
  []
[]

[VectorPostprocessors]
  [computed_data]
    type = PointValueSampler
    variable = 'response'
    points = '0.25 0.5 0
              0.75 0.5 0
              0.25 1.5 0
              0.75 1.5 0'
    sort_by = id
    outputs = none
  []

  [fixme_lynn_want_to_use_other_vpp]
    type = OptimizationResults
    outputs = optout
  []
  [opt_results]
    type = OptimizationVectorPostprocessor
    parameters = 'BCs/left/value BCs/right/value BCs/top/value'
    intial_values = '1 2 3'
    outputs = optout
  []
[]

[Outputs]
  console = true
  [exodus]
    file_base = 'zmaster/out'
    type = Exodus
  []
  [optout]
    type=CSV
  []
[]


# [Postprocessors]
#   # [objective]
#   #   type = VectorPostprocessorDifferenceMeasure
#   #   vectorpostprocessor_a = measurement_data
#   #   vectorpostprocessor_b = computed_data
#   #   vector_name_a = 'measurementData'
#   #   vector_name_b = 'response'
#   #   difference_type = l2
#   #   execute_on = 'timestep_end'
#   #   outputs = fromMaster
#   # []
# []
