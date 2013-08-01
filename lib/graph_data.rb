class GraphData < Hash
  
  def smooth(period)
    period += 1 unless period.odd?
    triangular_smooth(period)
  end
  
private

  def triangular_smooth(window)
    # Create triangular kernel of correct size
    kernel = Array.new(window,0.0)
    kernel.each_index do |i|
      kernel[i] = [(1.0 * (i+1)), (kernel.size - (1.0 * i))].min
    end
    # Convolve with kernel
    convolve(kernel)
  end

  def running_average(window)
    # Create flat kernel of correct size
    kernel = Array.new(window,1.0)
    # Convolve with kernel
    convolve(kernel)
  end

  def no_smoothing
    # Create an identity kernel
    kernel = Array.new(1,1.0)
    # Convolve with kernel
    convolve(kernel)
  end

  def convolve(kernel)
    # Check kernel size is odd
    raise "kernel must be uneven width" unless kernel.size.odd?
    # Get input data so we don't keep using the hash
    input = self[:values]
    # Allocate output array
    result = Array.new(input.length)
    # Extend input forward and backwards by half window width, filled with nil values
    halfwidth = (kernel.size / 2.0).floor
    extendedinput = Array.new(halfwidth, nil) + input + Array.new(halfwidth, nil)
    # convolve kernel with input
    extendedinput[0..(extendedinput.length-kernel.length)].each_index do |i|
      result[i] = nil
      unless extendedinput[i+halfwidth].nil?
        kernel_total = 0
        kernel.each_index do |k|
          val = kernel[k] * extendedinput[i+k] rescue nil
          unless val.nil?
            kernel_total += kernel[k]
            if result[i].nil?
              result[i] = val
            else
              result[i] += val
            end
          end          
        end
        result[i] /= kernel_total if kernel_total != 0 rescue nil
      end
    end
    # Done
    return result
  end

end
