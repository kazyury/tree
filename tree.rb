#!ruby -Ks

#= DirectoryTree
class DirectoryTree
	
	#== initialize
	#path�F��͑Ώۂ̃p�X
	#delimiter:�o�͓��e�̋�؂蕶��
	#with_file:�t�@�C�����o�͑ΏۂƂ��邩�ۂ��̐^�U
	def initialize(path,delimiter,with_file,max_depth)
		@path=path
		delimiter ? @indent=delimiter : @indent=','
		with_file ? @with_file=true : @with_file=false
		@max_depth=max_depth
		@depth=0
	end

	def out
		traverse(@path)
	end

	:private
	#== traverse
	#path���f�B���N�g���Ȃ�΃f�B���N�g�������o�͂�����ɁA
	#�f�B���N�g�����̊e�G���g���ɂ��ď������s���B
	#- �G���g�����t�@�C���̏ꍇ&@with_file���^�Ȃ�΃t�@�C�������o��
	#- �G���g�����f�B���N�g���̏ꍇ�A�ċA�I��traverse���ĂԁB
	def traverse(path)
		# �ő�[�x�𒴂����ꍇ�A����������return
		if depth_over?
			@depth-=1
			return
		end
		if File.directory?(path)
			print @indent*@depth
			print "#{File.basename(path)}/\n"
			Dir.foreach(path){|f|
				next if f=="." || f==".."
				if File.directory? path+"/"+f
					@depth+=1
					traverse(path+"/"+f)
				else
					if @with_file & ! depth_over?(1)
						print @indent*(@depth+1)
						print "#{File.basename(f)}\n"
					end
				end
			}
			@depth-=1
		end
	end

	def depth_over?(delta=0)
		@max_depth && @depth+delta > @max_depth
	end
end
		

# �w�肳�ꂽ�f�B���N�g���ȉ���traverse���ăf�B���N�g���c���[���o�͂���B
if __FILE__==$0
	require "optparse"
	OPTS={}
	ARGV.options{|opt|
		opt.on('-d','--delimiter=,','specify delimiter'){|v| OPTS[:d]=v }
		opt.on('-f','--with-file','out not only directory , but file'){|v| OPTS[:f]=v }
		opt.on('-m','--max_depth=none','specify traversal depth.default is not specified.'){|v| 
			if v.to_i >= 0
				OPTS[:m]=v.to_i 
			else
				puts "[ WARN ] using -m option with a positive number( x > 0 ). option was ignored."
			end
		}
		opt.parse!(ARGV)
	}
	if ARGV[0]
		dir=DirectoryTree.new(ARGV[0],OPTS[:d],OPTS[:f],OPTS[:m])
		dir.out
	else
		raise ArgumentError.new("MUST specify target dir. Use -h for help.")
	end
	
end
