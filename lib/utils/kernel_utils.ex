defmodule KernelUtils do

  unless function_exported?( :kernel, :then, 2) do
    @doc """
    Akin to the v1.12.0 Kernel.then/2 function.
    Fails to compile if the original Kernel function is found so to encourage using the former.
    """
    def then( value, fun) do
      fun.( value)
    end
  else
    IO.warn( "Kernel.then/2 function is defined so use it then instead of KernelUtils.then/2.")
  end
end
