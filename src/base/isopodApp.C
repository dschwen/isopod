#include "isopodApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
isopodApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy DirichletBC, that is, set DirichletBC default for preset = true
  params.set<bool>("use_legacy_dirichlet_bc") = false;

  return params;
}

isopodApp::isopodApp(InputParameters parameters) : MooseApp(parameters)
{
  isopodApp::registerAll(_factory, _action_factory, _syntax);
}

isopodApp::~isopodApp() {}

void
isopodApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"isopodApp"});
  Registry::registerActionsTo(af, {"isopodApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
isopodApp::registerApps()
{
  registerApp(isopodApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
isopodApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  isopodApp::registerAll(f, af, s);
}
extern "C" void
isopodApp__registerApps()
{
  isopodApp::registerApps();
}