// Package.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

class WorkerPool<Type: Worker where Type: AnyObject> : Pool {
    
    var inactive : [Type]
    var active = [Type]()
    var borrowed = [Type]()
    
    init (with workers: [Type]) {
        inactive = workers
    }
    
    func borrow() -> Type? {
        guard let worker = inactive.first else {
            return nil
        }
        borrowed.append(inactive.removeFirst())
        return worker
    }
    
    func takeBack(poolable: Type) {
        for index in 0...borrowed.count-1 {
            if ObjectIdentifier(active[index]) == ObjectIdentifier(poolable) {
                borrowed.remove(at: index)
                inactive.append(poolable)
            }
        }
    }
    
    func with(handler: (poolable: Type) throws -> Any?) throws -> Any? {
        guard let worker = inactive.first else {
            return nil
        }
        active.append(inactive.removeFirst())
        
        let result = try handler(poolable: worker)
        
        for index in 0...active.count-1 {
            if ObjectIdentifier(active[index]) == ObjectIdentifier(worker) {
                active.remove(at: index)
                inactive.append(worker)
            }
        }
        
        return result
    }
}