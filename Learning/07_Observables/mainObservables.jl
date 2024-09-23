using Observables

a = Observable(1);

doshit = on(a) do value
    println("Update arrived")
end

a[] = 2;
